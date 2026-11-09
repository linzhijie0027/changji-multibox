const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const read = p => fs.readFileSync(path.join(root, p), 'utf8');
const pkg = JSON.parse(read('package.json'));
assert.equal(pkg.productName, '畅际多开');
assert.equal(pkg.appId, 'io.github.linzhijie0027.changjimultibox');
assert.equal(pkg.license, 'Apache-2.0');
assert.match(read('LICENSE.md'), /Ferdium Contributors/);
assert.match(read('src/environment-remote.ts'), /app\.setName\('畅际多开'\)/);
assert.match(read('src/config.ts'), /sandboxServices: true/);
assert.match(read('src/config.ts'), /locale: 'zh'/);
assert.match(read('src/config.ts'), /automaticUpdates: false/);
assert.match(read('src/index.html'), /<title>畅际多开<\/title>/);
assert.match(read('src/models/Service.ts'), /service-/);
const en = JSON.parse(read('src/i18n/locales/en-US.json'));
assert.ok(Object.hasOwn(en, 'menu.view.reloadFerdium'));
assert.match(read('src/lib/Tray.ts'), /'tray\.quitFerdium'/);
for (const name of fs.readdirSync(path.join(root, 'src/i18n/locales'))) {
  if (!name.endsWith('.json')) continue;
  const locale = JSON.parse(read('src/i18n/locales/' + name));
  assert.ok(Object.keys(locale).every(key => !key.includes('畅际多开')));
}
console.log('PASS: branding, original license, independent identity and isolated service defaults');
