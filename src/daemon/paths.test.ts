import path from "node:path";
import { describe, expect, it } from "vitest";
import { resolveGatewayStateDir } from "./paths.js";

describe("resolveGatewayStateDir", () => {
  it("uses the default state dir when no overrides are set", () => {
    const env = { HOME: "/Users/test" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".aren"));
  });

  it("appends the profile suffix when set", () => {
    const env = { HOME: "/Users/test", AREN_PROFILE: "rescue" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".aren-rescue"));
  });

  it("treats default profiles as the base state dir", () => {
    const env = { HOME: "/Users/test", AREN_PROFILE: "Default" };
    expect(resolveGatewayStateDir(env)).toBe(path.join("/Users/test", ".aren"));
  });

  it("uses AREN_STATE_DIR when provided", () => {
    const env = { HOME: "/Users/test", AREN_STATE_DIR: "/var/lib/aren" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/var/lib/aren"));
  });

  it("expands ~ in AREN_STATE_DIR", () => {
    const env = { HOME: "/Users/test", AREN_STATE_DIR: "~/aren-state" };
    expect(resolveGatewayStateDir(env)).toBe(path.resolve("/Users/test/aren-state"));
  });

  it("preserves Windows absolute paths without HOME", () => {
    const env = { AREN_STATE_DIR: "C:\\State\\aren" };
    expect(resolveGatewayStateDir(env)).toBe("C:\\State\\aren");
  });
});
