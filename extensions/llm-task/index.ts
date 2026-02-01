import type { ArenPluginApi } from "../../src/plugins/types.js";
import { createLlmTaskTool } from "./src/llm-task-tool.js";

export default function register(api: ArenPluginApi) {
  api.registerTool(createLlmTaskTool(api), { optional: true });
}
