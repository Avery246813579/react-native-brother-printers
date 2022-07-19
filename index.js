// main index.js

import {NativeModules, NativeEventEmitter} from "react-native";

const {ReactNativeBrotherPrinters} = NativeModules;

export const LabelSizeDieCutW17H87 = 1;
export const LabelSizeDieCutW23H23 = 2;
export const LabelSizeDieCutW29H42 = 3;
export const LabelSizeDieCutW29H90 = 4;
export const LabelSizeDieCutW38H90 = 5;
export const LabelSizeDieCutW39H48 = 6;
export const LabelSizeDieCutW52H29 = 7;
export const LabelSizeDieCutW17H54 = 0;
export const LabelSizeDieCutW62H29 = 8;
export const LabelSizeDieCutW62H100 = 9;
export const LabelSizeDieCutW60H86 = 10;
export const LabelSizeDieCutW54H29 = 11;
export const LabelSizeDieCutW102H51 = 12;
export const LabelSizeDieCutW102H152 = 13;
export const LabelSizeDieCutW103H164 = 13;
export const LabelSizeRollW12 = 14;
export const LabelSizeRollW29 = 15;
export const LabelSizeRollW38 = 16;
export const LabelSizeRollW50 = 17;
export const LabelSizeRollW54 = 18;
export const LabelSizeRollW62 = 19;
export const LabelSizeRollW62RB = 20;
export const LabelSizeRollW102 = 21;
export const LabelSizeRollW103 = 22;
export const LabelSizeDTRollW90 = 23;
export const LabelSizeDTRollW102 = 24;
export const LabelSizeDTRollW102H51 = 25;
export const LabelSizeDTRollW102H152 = 26;

export const LabelSize = {
  LabelSizeDieCutW17H54,
  LabelSizeDieCutW17H87,
  LabelSizeDieCutW23H23,
  LabelSizeDieCutW29H42,
  LabelSizeDieCutW29H90,
  LabelSizeDieCutW38H90,
  LabelSizeDieCutW39H48,
  LabelSizeDieCutW52H29,
  LabelSizeDieCutW62H29,
  LabelSizeDieCutW62H100,
  LabelSizeDieCutW60H86,
  LabelSizeDieCutW54H29,
  LabelSizeDieCutW102H51,
  LabelSizeDieCutW102H152,
  LabelSizeDieCutW103H164,
  LabelSizeRollW12,
  LabelSizeRollW29,
  LabelSizeRollW38,
  LabelSizeRollW50,
  LabelSizeRollW54,
  LabelSizeRollW62,
  LabelSizeRollW62RB,
  LabelSizeRollW102,
  LabelSizeRollW103,
  LabelSizeDTRollW90,
  LabelSizeDTRollW102,
  LabelSizeDTRollW102H51,
  LabelSizeDTRollW102H152,
}

export const LabelNames = [
  "Die Cut 17mm x 54mm",
  "Die Cut 17mm x 87mm",
  "Die Cut 23mm x 23mm",
  "Die Cut 29mm x 42mm",
  "Die Cut 29mm x 90mm",
  "Die Cut 38mm x 90mm",
  "Die Cut 39mm x 48mm",
  "Die Cut 52mm x 29mm",
  "Die Cut 62mm x 29mm",
  "Die Cut 62mm x 10mm",
  "Die Cut 60mm x 86mm",
  "Die Cut 54mm x 29mm",
  "Die Cut 102mm x 51mm",
  "Die Cut 102mm x 152mm",
  "Die Cut 103mm x 164mm",
  "12mm",
  "29mm",
  "38mm",
  "50mm",
  "54mm",
  "62mm",
  "62mm RB",
  "10mm 2",
  "10mm 3",
  "DT 90mm",
  "DT 102mm",
  "DT 102mm x 51mm",
  "DT 102mm x 152mm",
];

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
 * @param params.autoCut            Boolean if the printer should auto cut the receipt/label
 * @param params.labelSize          Label size that we are printing with
 *
 * @return {Promise<*>}
 */
export async function printImage(device, uri, params = {}) {
  if (!params.labelSize) {
    return new Error("Label size must be given when printing a label");
  }

  return _printImage(device, uri, params);
}

// export async function printPDF(device, uri, params = {}) {
//   return _printPDF(device, uri, params);
// }

const listeners = new NativeEventEmitter(ReactNativeBrotherPrinters);

export function registerBrotherListener(key, method) {
  return listeners.addListener(key, method);
}
