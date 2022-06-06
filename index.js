const fs = require('fs').promises;
const path = require('path');

const axios = require('axios').default;
const cheerio = require('cheerio');
const { wrapper } = require('axios-cookiejar-support');
const { CookieJar } = require('tough-cookie');

require('dotenv').config();

const api = wrapper(axios.create({
    baseURL: 'http://hdlbits.01xz.net',
    withCredentials: true,
    jar: new CookieJar(),
}));

const hdlbitsLogin = async (username, password) => {
    const data = new URLSearchParams();
    data.append('vlg_username', username);
    data.append('password', password);
    data.append('login', 'Login');

    await api.get('/wiki/Special:VlgLogin');
    const response = await api.post('/wiki/Special:VlgLogin', data);

    const $ = cheerio.load(response.data);
    return $('#hcuser').length > 0;
};

const hdlbitsProblems = async () => {
    let problemMap = {};
    let result = [], stack = [];
    stack.push(result);
    const response = await api.get('/wiki/Problem_sets');

    const $ = cheerio.load(response.data);
    const contents = $('#mw-content-text');

    let lastTag = '';
    contents.children().each((_, el) => {
        switch (el.tagName) {
            case 'h2':
            case 'h3':
            case 'h4':
                const diff = parseInt(lastTag.slice(1)) - parseInt(el.tagName.slice(1)) + 1;
                for(let _ = 0; _ < diff; _++) {
                    stack.pop();
                }
                const level = {
                    title: $(el).text(),
                    children: [],
                };
                stack[stack.length - 1].push(level);
                stack.push(level.children);
                lastTag = el.tagName;
                break;
            case 'ul':
                $(el.children).each((_, el) => {
                    if (el.tagName == 'li') {
                        const link = $(el).find('a');
                        const status = $(el).find('span');
                        const url = link.attr('href');
                        let statusText;
                        if (status.hasClass('fa-check-circle')) {
                            statusText = 'finished';
                        } else if (status.hasClass('fa-minus-circle')) {
                            statusText = 'attempted';
                        } else {
                            statusText = 'new';
                        };
                        const problem = {
                            title: link.text(),
                            url: (url.startsWith('//') || url.startsWith('http:') || url.startsWith('https:')) ? url : `http://hdlbits.01xz.net${url.startsWith('/') ? url : ('/' + url)}`,
                            status: statusText,
                        };
                        stack[stack.length - 1].push(problem);
                    }
                })
                break;
        }
    });
    return result;
};

const hdlbitsLoad = async (problem, saved) => {
    const data = new URLSearchParams();
    data.append('tc', problem);
    data.append('name', saved);

    const response = await api.post('/load.php', data);
    return response.data['data'];
};

(async () => {
    const username = process.env['HDLBITS_USERNAME'];
    const password = process.env['HDLBITS_PASSWORD'];
    
    console.log(`Attempt to login HDLBits... (username: ${username})`)
    if (await hdlbitsLogin(username, password)) {
        console.log(`Logged in as ${username}.`);
    } else {
        console.error('Failed to login!');
    }

    const problems = await hdlbitsProblems();
    const iterate = async (list, f, nest) => {
        nest = nest || 1;
        for(const node of list) {
            if (node.children) {
                f('title', nest, node);
                await iterate(node.children, f, nest + 1);
            } else {
                f('problem', nest, node);
            }
        }
    }
    let markdown = process.env['README_TEMPLATE'] ? await fs.readFile(path.resolve(__dirname, process.env['README_TEMPLATE']), 'utf8') : '';
    await iterate(problems, async (type, nest, node) => {
        if (type == 'title') {
            markdown += (`\n${'#'.repeat(nest)} ${node.title}\n\n`);
        } else {
            if (node.status == 'finished') {
                const filename = node.url.split('/').at(-1) + '.v';
                markdown += `- [X] [${node.title}](${node.url}) [${filename}](./solutions/${filename})\n`;
                const page = (await api.get(node.url)).data;
                const tc = page.match(/send\("tc=([^"]+)"/)[1];
                const solution = await hdlbitsLoad(tc, '0');
                await fs.writeFile(path.resolve(__dirname, 'solutions', filename), solution);
            } else {
                markdown += `- [ ] [${node.title}](${node.url})\n`;
            }
        }
    });
    await fs.writeFile(path.resolve(__dirname, 'README.md'), markdown);
    console.log(markdown);
})();
