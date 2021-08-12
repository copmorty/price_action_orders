# Price Action Orders

[![build](https://github.com/copmorty/price_action_orders/actions/workflows/main.yml/badge.svg)](https://github.com/copmorty/price_action_orders/actions/workflows/main.yml)

A Flutter desktop application for cryptocurrency trading on the Binance exchange, through its API. The app allows to see cryptocurrency prices, spot wallet balances, to create market and limit orders from the spot account and it also allows to see open orders, order history and trade history. All these features work in real time, according to the user's movements and the exchange's operation.

![PAO-0 7 0](https://user-images.githubusercontent.com/23016725/129225811-853c1614-b426-492d-a436-9cb6dfb841cf.png)



## Getting Started

The app has two (independent) modes, Test and Production. Steps to run it:
- In order to run it in Test mode you will need an API key and secret from [Binance testnet](https://testnet.binance.vision/).
- In order to run it in Production mode you will need an API key and secret from [Binance](https://binance.zendesk.com/hc/en-us/articles/360002502072-How-to-create-API).
- Once you have one or both combinations of API key-secret, you have to put them in a configuration file, this is done by creating a copy of the **assets/config.json.example** file in the same folder without the **.example** extension, and replacing the values with your keys-secrets.
- The app by default runs in TEST mode, but if you want to run it in the real world you have to edit the variable **appMode** located in the file *lib/core/globals/variables*. Change it from **AppMode.TEST** to **AppMode.PRODUCTION**, and do not edit anything else in that file.
- Finally, the last step to run the app is to execute the command `flutter run` in the root of the project.

## About the project

This project was built follwoing the clean code architecture in order to be maintainable and testable through time, and without having to worry how big it gets. The project uses Riverpod for dependency injection and state management.


## License

This project is licensed under the [MIT License](https://github.com/copmorty/price_action_orders/blob/master/LICENSE).
