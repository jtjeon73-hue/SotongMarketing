/**
 * Rasterize brand SVGs to web favicon / PWA icons / OG image.
 *
 * Usage (from repo root):
 *   cd tool && npm install && node render_marketing_icons.js
 *   # or from tool/: npm run render
 */
const fs = require('fs');
const path = require('path');

async function main() {
  let sharp;
  try {
    sharp = require('sharp');
  } catch (err) {
    console.error('sharp is required. Run: cd tool && npm install');
    process.exit(1);
  }

  const root = path.join(__dirname, '..');
  const iconSvg = path.join(root, 'web/icons/sotong_marketing_icon.svg');
  const maskableSvg = path.join(
    root,
    'web/icons/sotong_marketing_icon_maskable.svg',
  );
  const ogSvg = path.join(root, 'web/og-image.svg');

  for (const p of [iconSvg, maskableSvg, ogSvg]) {
    if (!fs.existsSync(p)) {
      console.error('Missing source SVG:', p);
      process.exit(1);
    }
  }

  const jobs = [
    { src: iconSvg, out: path.join(root, 'web/favicon.png'), size: 48 },
    { src: iconSvg, out: path.join(root, 'web/icons/Icon-192.png'), size: 192 },
    { src: iconSvg, out: path.join(root, 'web/icons/Icon-512.png'), size: 512 },
    {
      src: maskableSvg,
      out: path.join(root, 'web/icons/Icon-maskable-192.png'),
      size: 192,
    },
    {
      src: maskableSvg,
      out: path.join(root, 'web/icons/Icon-maskable-512.png'),
      size: 512,
    },
  ];

  for (const job of jobs) {
    await sharp(job.src)
      .resize(job.size, job.size, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
      .png()
      .toFile(job.out);
    console.log('Wrote', path.relative(root, job.out), `(${job.size}x${job.size})`);
  }

  // OG: rasterize composed SVG (Korean text via system font in SVG <text>)
  const ogOut = path.join(root, 'web/og-image.png');
  await sharp(ogSvg)
    .resize(1200, 630, { fit: 'fill' })
    .png()
    .toFile(ogOut);
  console.log('Wrote', path.relative(root, ogOut), '(1200x630)');

  console.log('Done.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
