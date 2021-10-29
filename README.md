# react-native-brother-printers

React Native Brother Printers is a react-native module that will allow you to interact with the brother printers. 

## Getting started

`$ npm install react-native-brother-printers --save`

or 

`$ yarn add react-native-brother-printers`

### Mostly automatic installation

`$ cd ios;pod install`

or if you are using React Native before version 0.60, 

`$ react-native link react-native-brother-printers`

## Usage
To discover printers use the discoverPrinters function. You can pass in the option parameters `printerName` to change
the printer name, or V6 to enable ipv6 detection. Both parameters can be left blank. 

```javascript
import {discoverPrinters} from 'react-native-brother-printers';

discoverPrinters({
  printerName: "My Printer 123",
  V6: true,
});
```
