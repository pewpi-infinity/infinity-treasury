#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "[∞] CART INDEX"
echo "[∞] Repo: $(pwd)"
echo

# Collect carts safely
mapfile -t CARTS_SH < <(ls cart_*.sh 2>/dev/null | grep -v '^cart_index\.sh$' || true)
mapfile -t CARTS_PY < <(ls cart_*.py 2>/dev/null || true)

if [ "${#CARTS_SH[@]}" -eq 0 ] && [ "${#CARTS_PY[@]}" -eq 0 ]; then
  echo "[!] No carts found"
  exit 0
fi

echo "[∞] Shell carts:"
for c in "${CARTS_SH[@]}"; do
  echo "  - $c"
done
echo

echo "[∞] Python carts:"
for c in "${CARTS_PY[@]}"; do
  echo "  - $c"
done
echo

read -r -p "[?] Run all carts? (y/N): " RUNALL

if [[ "$RUNALL" == "y" || "$RUNALL" == "Y" ]]; then
  for c in "${CARTS_SH[@]}"; do
    echo "[→] Running $c"
    bash "$c"
  done

  for c in "${CARTS_PY[@]}"; do
    echo "[→] Running $c"
    python3 "$c"
  done
fi

read -r -p "[?] Push all changes after run? (y/N): " PUSH

if [[ "$PUSH" == "y" || "$PUSH" == "Y" ]]; then
  if [ -x ./cart_push_all.sh ]; then
    ./cart_push_all.sh
  else
    echo "[!] cart_push_all.sh not found or not executable"
  fi
fi

echo
echo "[✓] CART INDEX complete"
