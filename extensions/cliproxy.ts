import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";

const PROVIDER_ID = "cliproxy";
const DEFAULT_BASE_URL = "https://redacted.example/v1";
const DEFAULT_API_KEY = "!cat /redacted/token";
// The gateway's WAF blocks the OpenAI SDK's default `User-Agent: OpenAI/JS …`
// with a 403 "Your request was blocked." Send a Codex-style UA (the same client
// the gateway is known to accept) so requests pass through.
const DEFAULT_USER_AGENT = "codex_cli_rs/0.20.0";
const ZERO_COST = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 };
const THINKING_LEVEL_MAP = { minimal: "low", xhigh: "xhigh" };

const CODEX_MODELS: ProviderModelConfig[] = [
	{
		id: "gpt-5.3-codex-spark",
		name: "GPT-5.3 Codex Spark (CLIProxy)",
		reasoning: true,
		thinkingLevelMap: THINKING_LEVEL_MAP,
		input: ["text"],
		cost: ZERO_COST,
		contextWindow: 128000,
		maxTokens: 128000,
	},
	{
		id: "gpt-5.4",
		name: "GPT-5.4 (CLIProxy)",
		reasoning: true,
		thinkingLevelMap: THINKING_LEVEL_MAP,
		input: ["text", "image"],
		cost: ZERO_COST,
		contextWindow: 1050000,
		maxTokens: 128000,
	},
	{
		id: "gpt-5.4-mini",
		name: "GPT-5.4 mini (CLIProxy)",
		reasoning: true,
		thinkingLevelMap: THINKING_LEVEL_MAP,
		input: ["text", "image"],
		cost: ZERO_COST,
		contextWindow: 400000,
		maxTokens: 128000,
	},
	{
		id: "gpt-5.5",
		name: "GPT-5.5 (CLIProxy)",
		reasoning: true,
		thinkingLevelMap: THINKING_LEVEL_MAP,
		input: ["text", "image"],
		cost: ZERO_COST,
		contextWindow: 272000,
		maxTokens: 128000,
	},
];

function normalizeBaseUrl(value: string | undefined): string {
	const baseUrl = value?.trim() || DEFAULT_BASE_URL;
	return baseUrl.replace(/\/+$/, "");
}

export default function registerCLIProxy(pi: ExtensionAPI): void {
	pi.registerProvider(PROVIDER_ID, {
		name: "CLIProxy",
		baseUrl: normalizeBaseUrl(process.env.CLIPROXY_BASE_URL),
		apiKey: process.env.CLIPROXY_API_KEY?.trim() || DEFAULT_API_KEY,
		api: "openai-responses",
		headers: {
			"User-Agent": process.env.CLIPROXY_USER_AGENT?.trim() || DEFAULT_USER_AGENT,
		},
		models: CODEX_MODELS,
	});
}
