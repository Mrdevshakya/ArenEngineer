import type { ArenPluginApi } from "aren/plugin-sdk";
import { emptyPluginConfigSchema } from "aren/plugin-sdk";
import { createDiagnosticsOtelService } from "./src/service.js";

const plugin = {
  id: "diagnostics-otel",
  name: "Diagnostics OpenTelemetry",
  description: "Export diagnostics events to OpenTelemetry",
  configSchema: emptyPluginConfigSchema(),
  register(api: ArenPluginApi) {
    api.registerService(createDiagnosticsOtelService());
  },
};

export default plugin;
