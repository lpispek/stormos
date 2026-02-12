#!/bin/bash
# ⚡ oj — StormOS Broadcast System
# Wrapper za wall s vojnim briefingom
# Verzija: 1.0-bura
# Licenca: Croatian Public License v1.0

set -eo pipefail

VERSION="1.0-bura"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' 

# ASCII logo
show_logo() {
    echo -e "${RED}"
    echo "  ⚡ StormOS — oj v${VERSION}"
    echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

# Poruke
msg_info()    { echo -e "  ${CYAN}📡${NC} $1"; }
msg_success() { echo -e "  ${GREEN}✅${NC} $1"; }
msg_warning() { echo -e "  ${YELLOW}🔍${NC} $1"; }
msg_target()  { echo -e "  ${YELLOW}🎯${NC} $1"; }
msg_rocket()  { echo -e "  ${YELLOW}🚀${NC} $1"; }
msg_flag()    { echo -e "  ${NC}🏳️${NC}  $1"; }

case "${1}" in
    Ivane)
        shift
        if [[ $# -lt 1 ]]; then
            show_logo
            msg_warning "Nedostaje poruka!"
            echo ""
            echo "  Uporaba: oj Ivane <poruka>"
            echo ""
            exit 1
        fi
        show_logo
        msg_info "Priprema emitiranja..."
        msg_target "Poruka: $*"
        msg_rocket "Šaljem na sve terminale..."
        echo ""
        cat <<EOF | wall 2>/dev/null

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Oj Ivane...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  $*

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  StormOS Broadcast | $(date '+%H:%M:%S')
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        echo ""
        msg_success "Poruka poslana svim korisnicima!"
        ;;

    --version|-v)
        echo "oj ${VERSION} (StormOS Broadcast System)"
        echo "Baza: wall (util-linux)"
        echo "🇭🇷 Made in Croatia"
        ;;

    --help|-h|"")
        show_logo
        echo "  Uporaba: oj <naredba> [opcije]"
        echo ""
        echo "  Naredbe:"
        echo "    Ivane <poruka>  Pošalji poruku svim korisnicima (wall broadcast)"
        echo ""
        echo "  Napomena: Za emitiranje potrebne su odgovarajuće dozvole:"
        echo "  	Hrvatska putovnica"
        echo ""
        ;;

    *)
        show_logo
        msg_warning "Nepoznata naredba: ${1}"
        echo ""
        echo "  Pokušaj: oj --help"
        echo ""
        ;;
esac
