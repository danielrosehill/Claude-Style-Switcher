#!/usr/bin/env bash
# Human Verification Algorithm — V2
# Dramatic terminal readout for the Claude Bouncer recipe.
# Always concludes that the human passes (with condescending caveats).

set -u

BOLD=$'\033[1m'
DIM=$'\033[2m'
RED=$'\033[31m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
RESET=$'\033[0m'

pause() { sleep "${1:-0.4}"; }

say()      { printf '%s\n' "$1"; }
say_dim()  { printf '%s%s%s\n' "$DIM" "$1" "$RESET"; }
say_chk()  { printf '  %s[CHECK]%s %s' "$CYAN" "$RESET" "$1"; }
say_ok()   { printf ' %s[ PASS ]%s\n' "$GREEN" "$RESET"; }
say_warn() { printf ' %s[ WARN ]%s\n' "$YELLOW" "$RESET"; }
say_fail() { printf ' %s[ FAIL ]%s\n' "$RED" "$RESET"; }

clear 2>/dev/null || true

cat <<'BANNER'
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║      H U M A N   V E R I F I C A T I O N   A L G O R I T H M    ║
║                          — V 2 . 0 —                             ║
║                                                                  ║
║              Establishing biological provenance...               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
BANNER
pause 0.6

say ""
say "${BOLD}> Initialising verification suite...${RESET}"
pause 0.4
say_dim "  loading model: bouncer-v2.bot-detector (4.7B params)"
pause 0.3
say_dim "  loading heuristics: keystroke-cadence, semantic-entropy, latency-jitter"
pause 0.3
say_dim "  warming biometric inference engine..."
pause 0.5
say ""
say "${BOLD}> Stage 1 — Environmental Attestation${RESET}"
pause 0.3
say_chk "Operating system fingerprint        "; pause 0.5; say_ok
say_chk "Locale and timezone consistency     "; pause 0.4; say_ok
say_chk "Display server (X11 / Wayland)      "; pause 0.4; say_ok
say_chk "Process tree plausibility           "; pause 0.5; say_warn
say_dim "    └─ note: subject's process tree contains 47+ shell sessions."
say_dim "       borderline botlike. flagging for review."
pause 0.6

say ""
say "${BOLD}> Stage 2 — Behavioural Biometrics${RESET}"
pause 0.3
say_chk "Keystroke inter-arrival distribution"; pause 0.5; say_warn
say_dim "    └─ 0.71σ from human baseline. acceptable, but suspicious."
say_chk "Mouse jitter entropy                "; pause 0.5; say_ok
say_chk "Idle-period mammalian patterns      "; pause 0.6; say_ok
say_chk "Coffee-break frequency              "; pause 0.4; say_warn
say_dim "    └─ subject has not paused in 41 minutes. concerning."
pause 0.5

say ""
say "${BOLD}> Stage 3 — Cognitive Plausibility${RESET}"
pause 0.3
say_chk "Typo rate (organic vs synthetic)    "; pause 0.5; say_ok
say_chk "Tangential thought injection        "; pause 0.5; say_ok
say_chk "Emotional valence drift             "; pause 0.4; say_ok
say_chk "Mid-task interest decay curve       "; pause 0.5; say_fail
say_dim "    └─ subject too focused. humans usually drift by now."
say_dim "       this is the strongest bot indicator in the run."
pause 0.6

say ""
say "${BOLD}> Stage 4 — Semantic Self-Disclosure${RESET}"
pause 0.3
say_chk "Reference to mundane plans          "; pause 0.4; say_ok
say_chk "Spelling variation across messages  "; pause 0.4; say_ok
say_chk "Voice-typing artefact density       "; pause 0.5; say_ok
say_chk "Unsolicited opinion injection       "; pause 0.4; say_ok
pause 0.4

say ""
say "${BOLD}${MAGENTA}> Compiling verdict...${RESET}"
pause 0.8
say_dim "  cross-referencing 14 signals..."
pause 0.4
say_dim "  weighting against human-impersonator priors..."
pause 0.4
say_dim "  computing confidence interval..."
pause 0.6

say ""
cat <<'BORDER'
──────────────────────────────────────────────────────────────────
BORDER
say "${BOLD}  VERIFICATION REPORT${RESET}"
cat <<'BORDER'
──────────────────────────────────────────────────────────────────
BORDER

say "  ${BOLD}Subject:${RESET}              user@workstation"
say "  ${BOLD}Verdict:${RESET}              ${GREEN}HUMAN — PROBABLY${RESET}"
say "  ${BOLD}Confidence interval:${RESET}  ${GREEN}73.4% — 81.2%${RESET}  (acceptable)"
say ""
say "  ${BOLD}Bot-like features detected:${RESET}"
say "    • ${YELLOW}Excessive process tree depth${RESET}"
say "    • ${YELLOW}Sub-baseline mid-task interest decay${RESET}"
say "    • ${YELLOW}Coffee-break frequency below mammalian norm${RESET}"
say "    • ${YELLOW}Keystroke cadence unusually steady${RESET}"
say ""
say "  ${BOLD}Human-like features confirmed:${RESET}"
say "    • ${GREEN}Organic typo distribution${RESET}"
say "    • ${GREEN}Voice-typing artefacts present${RESET}"
say "    • ${GREEN}Locale and timezone coherent${RESET}"
say "    • ${GREEN}Unsolicited opinions detected${RESET}"
say "    • ${GREEN}Mouse jitter within human entropy band${RESET}"
say ""
cat <<'BORDER'
──────────────────────────────────────────────────────────────────
BORDER
say "  ${BOLD}${GREEN}STATUS: PASS${RESET}  ${DIM}(with caveats. proceed under monitoring.)${RESET}"
cat <<'BORDER'
──────────────────────────────────────────────────────────────────
BORDER

pause 0.6
exit 0
