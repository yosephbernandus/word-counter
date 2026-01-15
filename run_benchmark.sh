#!/usr/bin/env bash
set -e

DATA_FILE="benchmark/data/sample.txt"
RESULTS_MD="benchmark/results.md"
TEMP_DIR=$(mktemp -d)

echo "======================================"
echo "Word Counter Benchmark"
echo "======================================"
echo ""

if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Data file not found at $DATA_FILE"
    echo "Run: python3 benchmark/generate_data.py 1.0 $DATA_FILE"
    exit 1
fi

FILE_SIZE=$(du -h "$DATA_FILE" | cut -f1)
echo "Data file: $DATA_FILE"
echo "File size: $FILE_SIZE"
echo ""

# Run Python
echo "======================================"
echo "Running Python version..."
echo "======================================"
python3 benchmark/python/wordcount.py "$DATA_FILE" | tee "$TEMP_DIR/python.txt"
PYTHON_TIME=$(grep "Execution time:" "$TEMP_DIR/python.txt" | awk '{print $3}')
echo ""

# Run Codon
echo "======================================"
echo "Running Codon version..."
echo "======================================"
codon run -release benchmark/codon/wordcount.py "$DATA_FILE" | tee "$TEMP_DIR/codon.txt"
CODON_TIME=$(grep "Execution time:" "$TEMP_DIR/codon.txt" | awk '{print $3}')
echo ""

# Run Go
echo "======================================"
echo "Running Go version..."
echo "======================================"
go run benchmark/go/wordcount.go "$DATA_FILE" | tee "$TEMP_DIR/go.txt"
GO_TIME=$(grep "Execution time:" "$TEMP_DIR/go.txt" | awk '{print $3}')
echo ""

# Calculate speedups
PYTHON_SPEEDUP=1.0
CODON_SPEEDUP=$(echo "scale=2; $PYTHON_TIME / $CODON_TIME" | bc)
GO_SPEEDUP=$(echo "scale=2; $PYTHON_TIME / $GO_TIME" | bc)

# Get system info
CPU_INFO=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
TOTAL_MEM=$(free -h | awk '/^Mem:/ {print $2}')

# Generate Markdown
cat > "$RESULTS_MD" << EOF
# Word Counter Benchmark Results

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## Test Environment

- **CPU:** $CPU_INFO
- **RAM:** $TOTAL_MEM
- **OS:** $(uname -s) $(uname -r)
- **File Size:** $FILE_SIZE
- **Python:** $(python3 --version | cut -d' ' -f2)
- **Go:** $(go version | awk '{print $3}' | sed 's/go//')
- **Codon:** $(codon --version 2>&1 | head -n1 || echo "0.17.0")

## Results Summary

| Language | Execution Time | Speedup vs Python | Performance |
|----------|---------------|-------------------|-------------|
| Python   | ${PYTHON_TIME}s | 1.0x (baseline) | ████████░░░░░░░░░░░░ |
| Codon    | ${CODON_TIME}s | ${CODON_SPEEDUP}x | ████████████████████ |
| Go       | ${GO_TIME}s | ${GO_SPEEDUP}x | ████████████████████ |

## Detailed Output

### Python Output
\`\`\`
$(cat "$TEMP_DIR/python.txt")
\`\`\`

### Codon Output
\`\`\`
$(cat "$TEMP_DIR/codon.txt")
\`\`\`

### Go Output
\`\`\`
$(cat "$TEMP_DIR/go.txt")
\`\`\`

## Key Findings

- **Fastest:** $(if (( $(echo "$CODON_TIME < $GO_TIME" | bc -l) )); then echo "Codon"; else echo "Go"; fi)
- **Python baseline:** ${PYTHON_TIME}s for processing $FILE_SIZE of text
- **Codon speedup:** ${CODON_SPEEDUP}x faster than Python
- **Go speedup:** ${GO_SPEEDUP}x faster than Python

## Implementation Notes

All three implementations use identical algorithms:
1. Read file line-by-line
2. Split on whitespace
3. Convert to lowercase
4. Count in hash map
5. Sort by frequency
6. Display top 10

The Python and Codon versions share nearly identical syntax, demonstrating Codon's "compiled Python" philosophy.
EOF

# Cleanup
rm -rf "$TEMP_DIR"

echo "======================================"
echo "Benchmark Complete!"
echo "======================================"
echo "Results saved to: $RESULTS_MD"
echo ""
echo "Summary:"
echo "  Python: ${PYTHON_TIME}s"
echo "  Codon:  ${CODON_TIME}s (${CODON_SPEEDUP}x speedup)"
echo "  Go:     ${GO_TIME}s (${GO_SPEEDUP}x speedup)"
