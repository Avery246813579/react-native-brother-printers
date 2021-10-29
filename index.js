// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const {
  discoverPrinters: _discoverPrinters,
} = ReactNativeBrotherPrinters;

/**
 * Starts the discovery process for brother printers
 *
 * @param params
 * @param params.V6             If we should searching using IP v6.
 * @param params.printerName    If we should name the printer something specific.
 *
 * @return {Promise<void>}
 */
export async function discoverPrinters(params = {}) {
  return _discoverPrinters(params);
}
