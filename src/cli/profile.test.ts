import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "aren",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "aren", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "aren", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "aren", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "aren", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "aren", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "aren", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (dev first)", () => {
    const res = parseCliProfileArgs(["node", "aren", "--dev", "--profile", "work", "status"]);
    expect(res.ok).toBe(false);
  });

  it("rejects combining --dev with --profile (profile first)", () => {
    const res = parseCliProfileArgs(["node", "aren", "--profile", "work", "--dev", "status"]);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join("/home/peter", ".aren-dev");
    expect(env.AREN_PROFILE).toBe("dev");
    expect(env.AREN_STATE_DIR).toBe(expectedStateDir);
    expect(env.AREN_CONFIG_PATH).toBe(path.join(expectedStateDir, "aren.json"));
    expect(env.AREN_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      AREN_STATE_DIR: "/custom",
      AREN_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.AREN_STATE_DIR).toBe("/custom");
    expect(env.AREN_GATEWAY_PORT).toBe("19099");
    expect(env.AREN_CONFIG_PATH).toBe(path.join("/custom", "aren.json"));
  });
});

describe("formatCliCommand", () => {
  it("returns command unchanged when no profile is set", () => {
    expect(formatCliCommand("aren doctor --fix", {})).toBe("aren doctor --fix");
  });

  it("returns command unchanged when profile is default", () => {
    expect(formatCliCommand("aren doctor --fix", { AREN_PROFILE: "default" })).toBe(
      "aren doctor --fix",
    );
  });

  it("returns command unchanged when profile is Default (case-insensitive)", () => {
    expect(formatCliCommand("aren doctor --fix", { AREN_PROFILE: "Default" })).toBe(
      "aren doctor --fix",
    );
  });

  it("returns command unchanged when profile is invalid", () => {
    expect(formatCliCommand("aren doctor --fix", { AREN_PROFILE: "bad profile" })).toBe(
      "aren doctor --fix",
    );
  });

  it("returns command unchanged when --profile is already present", () => {
    expect(
      formatCliCommand("aren --profile work doctor --fix", { AREN_PROFILE: "work" }),
    ).toBe("aren --profile work doctor --fix");
  });

  it("returns command unchanged when --dev is already present", () => {
    expect(formatCliCommand("aren --dev doctor", { AREN_PROFILE: "dev" })).toBe(
      "aren --dev doctor",
    );
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("aren doctor --fix", { AREN_PROFILE: "work" })).toBe(
      "aren --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("aren doctor --fix", { AREN_PROFILE: "  jbaren  " })).toBe(
      "aren --profile jbaren doctor --fix",
    );
  });

  it("handles command with no args after aren", () => {
    expect(formatCliCommand("aren", { AREN_PROFILE: "test" })).toBe(
      "aren --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm aren doctor", { AREN_PROFILE: "work" })).toBe(
      "pnpm aren --profile work doctor",
    );
  });
});
