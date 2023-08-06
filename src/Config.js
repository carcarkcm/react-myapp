// Fetch config variables defined in window.*
const envSettings = window;

export const configuration = {
  foo: envSettings.FOO,
  bar: envSettings.BAR
}