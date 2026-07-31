const fs = require('fs');

function addKeys(file, keys) {
  let content = fs.readFileSync(file, 'utf8');
  // Remove the appended text that I accidentally added
  content = content.replace(/\}\s*"discoverTopCountries"[\s\S]*/, '}');
  
  let json = JSON.parse(content);
  Object.assign(json, keys);
  fs.writeFileSync(file, JSON.stringify(json, null, 2));
}

const enKeys = {
  "discoverTopCountries": "Discover Flavors by Country",
  "discoverTopRated": "Top Rated Beers",
  "beersCount": "{count} beers",
  "@beersCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
};

const plKeys = {
  "discoverTopCountries": "Odkryj smaki z różnych krajów",
  "discoverTopRated": "Najlepiej oceniane",
  "beersCount": "{count} piw",
  "@beersCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
};

addKeys('lib/l10n/app_en.arb', enKeys);
addKeys('lib/l10n/app_pl.arb', plKeys);

