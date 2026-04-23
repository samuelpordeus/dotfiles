/**
 * Compact tool output for built-in Pi tools.
 *
 * Collapsed tool rows stay concise in the main conversation.
 * Expanding a row still shows the detailed output for text-based results.
 *
 * This intentionally overrides the built-in renderers for the most common
 * high-volume tools: read, bash, edit, write, find, grep, and ls.
 */

import type {
  BashToolDetails,
  EditToolDetails,
  ExtensionAPI,
  FindToolDetails,
  GrepToolDetails,
  LsToolDetails,
  ReadToolDetails,
} from "@mariozechner/pi-coding-agent";
import {
  createBashToolDefinition,
  createEditToolDefinition,
  createFindToolDefinition,
  createGrepToolDefinition,
  createLsToolDefinition,
  createReadToolDefinition,
  createWriteToolDefinition,
} from "@mariozechner/pi-coding-agent";
import { Text } from "@mariozechner/pi-tui";
import { homedir } from "node:os";

function shortenPath(path: string): string {
  const home = homedir();
  return path.startsWith(home) ? `~${path.slice(home.length)}` : path;
}

function getTextContent(result: { content: Array<{ type: string; text?: string }> }): string {
  const textContent = result.content.find((entry) => entry.type === "text" && typeof entry.text === "string");
  return textContent?.text ?? "";
}

function nonEmptyLineCount(text: string): number {
  if (!text.trim()) return 0;
  return text.split("\n").filter((line) => line.trim().length > 0).length;
}

function renderExpandedText(text: string, theme: any): Text {
  if (!text.trim()) return new Text("", 0, 0);
  const output = text
    .trim()
    .split("\n")
    .map((line) => theme.fg("toolOutput", line))
    .join("\n");
  return new Text(`\n${output}`, 0, 0);
}

const toolCache = new Map<string, ReturnType<typeof createBuiltInDefinitions>>();

function createBuiltInDefinitions(cwd: string) {
  return {
    read: createReadToolDefinition(cwd),
    bash: createBashToolDefinition(cwd),
    edit: createEditToolDefinition(cwd),
    write: createWriteToolDefinition(cwd),
    find: createFindToolDefinition(cwd),
    grep: createGrepToolDefinition(cwd),
    ls: createLsToolDefinition(cwd),
  };
}

function getBuiltInDefinitions(cwd: string) {
  let tools = toolCache.get(cwd);
  if (!tools) {
    tools = createBuiltInDefinitions(cwd);
    toolCache.set(cwd, tools);
  }
  return tools;
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "read",
    label: "read",
    description: getBuiltInDefinitions(process.cwd()).read.description,
    parameters: getBuiltInDefinitions(process.cwd()).read.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).read.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const path = shortenPath(args.path || "");
      let text = `${theme.fg("toolTitle", theme.bold("read"))} ${theme.fg("accent", path || "...")}`;
      if (args.offset !== undefined || args.limit !== undefined) {
        const parts: string[] = [];
        if (args.offset !== undefined) parts.push(`offset=${args.offset}`);
        if (args.limit !== undefined) parts.push(`limit=${args.limit}`);
        text += theme.fg("dim", ` (${parts.join(", ")})`);
      }
      return new Text(text, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme) {
      if (isPartial) return new Text(theme.fg("warning", "Reading..."), 0, 0);
      if (expanded) {
        const text = getTextContent(result as any);
        if (text) return renderExpandedText(text, theme);
        if ((result as any).content.some((entry: any) => entry.type === "image")) {
          return new Text(`\n${theme.fg("success", "Image loaded")}`, 0, 0);
        }
        return new Text("", 0, 0);
      }

      const details = (result as any).details as ReadToolDetails | undefined;
      const text = getTextContent(result as any);
      if (!text && (result as any).content.some((entry: any) => entry.type === "image")) {
        return new Text(theme.fg("muted", "image"), 0, 0);
      }
      const lineCount = text ? text.split("\n").length : 0;
      let summary = theme.fg("muted", `${lineCount} lines`);
      if (details?.truncation?.truncated) {
        summary += theme.fg("warning", ` (truncated from ${details.truncation.totalLines})`);
      }
      return new Text(summary, 0, 0);
    },
  });

  pi.registerTool({
    name: "bash",
    label: "bash",
    description: getBuiltInDefinitions(process.cwd()).bash.description,
    parameters: getBuiltInDefinitions(process.cwd()).bash.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).bash.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const command = args.command || "...";
      const preview = command.length > 100 ? `${command.slice(0, 97)}...` : command;
      let text = theme.fg("toolTitle", theme.bold(`$ ${preview}`));
      if (args.timeout) text += theme.fg("dim", ` (timeout ${args.timeout}s)`);
      return new Text(text, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme, context) {
      if (isPartial) return new Text(theme.fg("warning", "Running..."), 0, 0);
      const text = getTextContent(result as any);
      if (expanded) return renderExpandedText(text, theme);

      const details = (result as any).details as BashToolDetails | undefined;
      const lineCount = nonEmptyLineCount(text);
      let summary = context.isError ? theme.fg("error", "error") : theme.fg("success", "done");
      if (lineCount > 0) summary += theme.fg("muted", ` (${lineCount} lines)`);
      if (details?.truncation?.truncated) summary += theme.fg("warning", " [truncated]");
      return new Text(summary, 0, 0);
    },
  });

  pi.registerTool({
    name: "edit",
    label: "edit",
    description: getBuiltInDefinitions(process.cwd()).edit.description,
    parameters: getBuiltInDefinitions(process.cwd()).edit.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).edit.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const path = shortenPath(args.path || "");
      return new Text(`${theme.fg("toolTitle", theme.bold("edit"))} ${theme.fg("accent", path || "...")}`, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme, context) {
      if (isPartial) return new Text(theme.fg("warning", "Editing..."), 0, 0);
      const details = (result as any).details as EditToolDetails | undefined;
      const text = getTextContent(result as any);
      if (expanded) {
        const expandedText = details?.diff || text;
        return renderExpandedText(expandedText, theme);
      }
      if (context.isError) {
        const firstLine = text.split("\n").find((line) => line.trim()) || "Edit failed";
        return new Text(theme.fg("error", firstLine), 0, 0);
      }
      if (!details?.diff) return new Text(theme.fg("success", "applied"), 0, 0);

      let additions = 0;
      let removals = 0;
      for (const line of details.diff.split("\n")) {
        if (line.startsWith("+") && !line.startsWith("+++")) additions += 1;
        if (line.startsWith("-") && !line.startsWith("---")) removals += 1;
      }
      const summary = `${theme.fg("success", `+${additions}`)}${theme.fg("dim", " / ")}${theme.fg("error", `-${removals}`)}`;
      return new Text(summary, 0, 0);
    },
  });

  pi.registerTool({
    name: "write",
    label: "write",
    description: getBuiltInDefinitions(process.cwd()).write.description,
    parameters: getBuiltInDefinitions(process.cwd()).write.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).write.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const path = shortenPath(args.path || "");
      const lineCount = typeof args.content === "string" ? args.content.split("\n").length : 0;
      const info = lineCount > 0 ? theme.fg("dim", ` (${lineCount} lines)`) : "";
      return new Text(`${theme.fg("toolTitle", theme.bold("write"))} ${theme.fg("accent", path || "...")}${info}`, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme, context) {
      if (isPartial) return new Text(theme.fg("warning", "Writing..."), 0, 0);
      const text = getTextContent(result as any);
      if (expanded) return renderExpandedText(text, theme);
      if (context.isError && text) {
        const firstLine = text.split("\n").find((line) => line.trim()) || "Write failed";
        return new Text(theme.fg("error", firstLine), 0, 0);
      }
      return new Text(theme.fg("success", "written"), 0, 0);
    },
  });

  pi.registerTool({
    name: "find",
    label: "find",
    description: getBuiltInDefinitions(process.cwd()).find.description,
    parameters: getBuiltInDefinitions(process.cwd()).find.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).find.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const pattern = args.pattern || "";
      const path = shortenPath(args.path || ".");
      let text = `${theme.fg("toolTitle", theme.bold("find"))} ${theme.fg("accent", pattern)}`;
      text += theme.fg("toolOutput", ` in ${path}`);
      if (args.limit !== undefined) text += theme.fg("dim", ` (limit ${args.limit})`);
      return new Text(text, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme) {
      if (isPartial) return new Text(theme.fg("warning", "Searching..."), 0, 0);
      const details = (result as any).details as FindToolDetails | undefined;
      const text = getTextContent(result as any);
      if (expanded) return renderExpandedText(text, theme);
      const count = nonEmptyLineCount(text);
      let summary = theme.fg("muted", `${count} files`);
      if (details?.truncation?.truncated) summary += theme.fg("warning", " [truncated]");
      return new Text(summary, 0, 0);
    },
  });

  pi.registerTool({
    name: "grep",
    label: "grep",
    description: getBuiltInDefinitions(process.cwd()).grep.description,
    parameters: getBuiltInDefinitions(process.cwd()).grep.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).grep.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const pattern = args.pattern || "";
      const path = shortenPath(args.path || ".");
      let text = `${theme.fg("toolTitle", theme.bold("grep"))} ${theme.fg("accent", `/${pattern}/`)}`;
      text += theme.fg("toolOutput", ` in ${path}`);
      if (args.glob) text += theme.fg("dim", ` (${args.glob})`);
      if (args.limit !== undefined) text += theme.fg("dim", ` limit ${args.limit}`);
      return new Text(text, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme) {
      if (isPartial) return new Text(theme.fg("warning", "Searching..."), 0, 0);
      const details = (result as any).details as GrepToolDetails | undefined;
      const text = getTextContent(result as any);
      if (expanded) return renderExpandedText(text, theme);
      const count = nonEmptyLineCount(text);
      let summary = theme.fg("muted", `${count} matches`);
      if (details?.matchLimitReached) summary += theme.fg("warning", ` (limit ${details.matchLimitReached})`);
      if (details?.truncation?.truncated || details?.linesTruncated) summary += theme.fg("warning", " [truncated]");
      return new Text(summary, 0, 0);
    },
  });

  pi.registerTool({
    name: "ls",
    label: "ls",
    description: getBuiltInDefinitions(process.cwd()).ls.description,
    parameters: getBuiltInDefinitions(process.cwd()).ls.parameters,

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return getBuiltInDefinitions(ctx.cwd).ls.execute(toolCallId, params, signal, onUpdate, ctx);
    },

    renderCall(args, theme) {
      const path = shortenPath(args.path || ".");
      let text = `${theme.fg("toolTitle", theme.bold("ls"))} ${theme.fg("accent", path)}`;
      if (args.limit !== undefined) text += theme.fg("dim", ` (limit ${args.limit})`);
      return new Text(text, 0, 0);
    },

    renderResult(result, { expanded, isPartial }, theme) {
      if (isPartial) return new Text(theme.fg("warning", "Listing..."), 0, 0);
      const details = (result as any).details as LsToolDetails | undefined;
      const text = getTextContent(result as any);
      if (expanded) return renderExpandedText(text, theme);
      const count = nonEmptyLineCount(text);
      let summary = theme.fg("muted", `${count} entries`);
      if (details?.truncation?.truncated) summary += theme.fg("warning", " [truncated]");
      return new Text(summary, 0, 0);
    },
  });
}
