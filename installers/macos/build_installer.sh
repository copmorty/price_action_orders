dmg_file="price_action_orders.dmg"

cd ../..

fvm flutter clean
fvm flutter pub get
fvm flutter build macos

cd installers/macos

if [ -f "$dmg_file" ]; then
    rm -f "$dmg_file"
fi

appdmg ./dmg_creator/config.json ./"$dmg_file"
