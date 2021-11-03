// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

const {
  discoverPrinters: _discoverPrinters,
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

export async function discoverReader() {

}

export async function printImage(device, params = {}) {
  return _printImage(device, params);
}

export async function printPDF(params = {}) {
  return _printPDF(params);
}

const listeners = new NativeEventEmitter(ReactNativeBrotherPrinters);

export function registerBrotherListener(key, method) {
  return listeners.addListener(key, method);
}
