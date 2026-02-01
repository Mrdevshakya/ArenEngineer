import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it("detects help/version flags", () => {
    expect(hasHelpOrVersion(["node", "aren", "--help"])).toBe(true);
    expect(hasHelpOrVersion(["node", "aren", "-V"])).toBe(true);
    expect(hasHelpOrVersion(["node", "aren", "status"])).toBe(false);
  });

  it("extracts command path ignoring flags and terminator", () => {
    expect(getCommandPath(["node", "aren", "status", "--json"], 2)).toEqual(["status"]);
    expect(getCommandPath(["node", "aren", "agents", "list"], 2)).toEqual(["agents", "list"]);
    expect(getCommandPath(["node", "aren", "status", "--", "ignored"], 2)).toEqual(["status"]);
  });

  it("returns primary command", () => {
    expect(getPrimaryCommand(["node", "aren", "agents", "list"])).toBe("agents");
    expect(getPrimaryCommand(["node", "aren"])).toBeNull();
  });

  it("parses boolean flags and ignores terminator", () => {
    expect(hasFlag(["node", "aren", "status", "--json"], "--json")).toBe(true);
    expect(hasFlag(["node", "aren", "--", "--json"], "--json")).toBe(false);
  });

  it("extracts flag values with equals and missing values", () => {
    expect(getFlagValue(["node", "aren", "status", "--timeout", "5000"], "--timeout")).toBe(
      "5000",
    );
    expect(getFlagValue(["node", "aren", "status", "--timeout=2500"], "--timeout")).toBe(
      "2500",
    );
    expect(getFlagValue(["node", "aren", "status", "--timeout"], "--timeout")).toBeNull();
    expect(getFlagValue(["node", "aren", "status", "--timeout", "--json"], "--timeout")).toBe(
      null,
    );
    expect(getFlagValue(["node", "aren", "--", "--timeout=99"], "--timeout")).toBeUndefined();
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "aren", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "aren", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "aren", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it("parses positive integer flag values", () => {
    expect(getPositiveIntFlagValue(["node", "aren", "status"], "--timeout")).toBeUndefined();
    expect(
      getPositiveIntFlagValue(["node", "aren", "status", "--timeout"], "--timeout"),
    ).toBeNull();
    expect(
      getPositiveIntFlagValue(["node", "aren", "status", "--timeout", "5000"], "--timeout"),
    ).toBe(5000);
    expect(
      getPositiveIntFlagValue(["node", "aren", "status", "--timeout", "nope"], "--timeout"),
    ).toBeUndefined();
  });

  it("builds parse argv from raw args", () => {
    const nodeArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node", "aren", "status"],
    });
    expect(nodeArgv).toEqual(["node", "aren", "status"]);

    const versionedNodeArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node-22", "aren", "status"],
    });
    expect(versionedNodeArgv).toEqual(["node-22", "aren", "status"]);

    const versionedNodeWindowsArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node-22.2.0.exe", "aren", "status"],
    });
    expect(versionedNodeWindowsArgv).toEqual(["node-22.2.0.exe", "aren", "status"]);

    const versionedNodePatchlessArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node-22.2", "aren", "status"],
    });
    expect(versionedNodePatchlessArgv).toEqual(["node-22.2", "aren", "status"]);

    const versionedNodeWindowsPatchlessArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node-22.2.exe", "aren", "status"],
    });
    expect(versionedNodeWindowsPatchlessArgv).toEqual(["node-22.2.exe", "aren", "status"]);

    const versionedNodeWithPathArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["/usr/bin/node-22.2.0", "aren", "status"],
    });
    expect(versionedNodeWithPathArgv).toEqual(["/usr/bin/node-22.2.0", "aren", "status"]);

    const nodejsArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["nodejs", "aren", "status"],
    });
    expect(nodejsArgv).toEqual(["nodejs", "aren", "status"]);

    const nonVersionedNodeArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["node-dev", "aren", "status"],
    });
    expect(nonVersionedNodeArgv).toEqual(["node", "aren", "node-dev", "aren", "status"]);

    const directArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["aren", "status"],
    });
    expect(directArgv).toEqual(["node", "aren", "status"]);

    const bunArgv = buildParseArgv({
      programName: "aren",
      rawArgs: ["bun", "src/entry.ts", "status"],
    });
    expect(bunArgv).toEqual(["bun", "src/entry.ts", "status"]);
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "aren",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "aren", "status"]);
  });

  it("decides when to migrate state", () => {
    expect(shouldMigrateState(["node", "aren", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "aren", "health"])).toBe(false);
    expect(shouldMigrateState(["node", "aren", "sessions"])).toBe(false);
    expect(shouldMigrateState(["node", "aren", "memory", "status"])).toBe(false);
    expect(shouldMigrateState(["node", "aren", "agent", "--message", "hi"])).toBe(false);
    expect(shouldMigrateState(["node", "aren", "agents", "list"])).toBe(true);
    expect(shouldMigrateState(["node", "aren", "message", "send"])).toBe(true);
  });

  it("reuses command path for migrate state decisions", () => {
    expect(shouldMigrateStateFromPath(["status"])).toBe(false);
    expect(shouldMigrateStateFromPath(["agents", "list"])).toBe(true);
  });
});
