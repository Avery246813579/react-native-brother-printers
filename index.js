// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const {
  discoverPrinters: _discoverPrinters,
  pingPrinter: _pingPrinter,
  printImage: _printImage,
  printPDF: _printPDF,
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

/**
 * Checks if a reader is discoverable
 *
 * @param ip
 *
 * @return {Promise<void>}
 */
export async function pingPrinter(ip) {
  return _pingPrinter(ip);
}

/**
 * Prints an image
 *
 * @param device                  Device object
 * @param uri                     URI of image wanting to be printed
 * @param params
 * @param params.autoCut          Boolean if the printer should auto cut the receipt/label
 *
 * @return {Promise<*>}
 */
export async function printImage(device, uri, params = {}) {
  return _printImage(device, uri, params);
}

// export async function printPDF(device, uri, params = {}) {
//   return _printPDF(device, uri, params);
// }

const listeners = new NativeEventEmitter(ReactNativeBrotherPrinters);

export function registerBrotherListener(key, method) {
  return listeners.addListener(key, method);
}
