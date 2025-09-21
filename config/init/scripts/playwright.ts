import type { CustomArgs, CustomOptions } from "jsr:@ghostmind/run";
import { $ } from "npm:zx@8.1.3";

export default async function (_arg: CustomArgs, opts: CustomOptions) {
  $.verbose = true;

  const PLAYWRIGHT_DATA_DIR = Deno.env.get("PLAYWRIGHT_DATA_DIR");
  const PLAYWRIGHT_OUTPUT_DIR = Deno.env.get("PLAYWRIGHT_OUTPUT_DIR");
  const PLAYWRIGHT_PORT = Deno.env.get("PLAYWRIGHT_PORT");

  await $`run misc stop ${PLAYWRIGHT_PORT}`;

  const playwrightRunner = [
    "npx",
    "@playwright/mcp@latest",
    `--port=${PLAYWRIGHT_PORT}`,
    `--user-data-dir=${PLAYWRIGHT_DATA_DIR}`,
    `--output-dir=${PLAYWRIGHT_OUTPUT_DIR}`,
  ];

  await Promise.all([$`${playwrightRunner}`]);
}
