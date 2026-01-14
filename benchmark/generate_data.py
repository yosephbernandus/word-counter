import random
import sys

WORDS = [
    "the",
    "be",
    "to",
    "of",
    "and",
    "a",
    "in",
    "that",
    "have",
    "I",
    "it",
    "for",
    "not",
    "on",
    "with",
    "he",
    "as",
    "you",
    "do",
    "at",
    "this",
    "but",
    "his",
    "by",
    "from",
    "they",
    "we",
    "say",
    "her",
    "she",
    "or",
    "an",
    "will",
    "my",
    "one",
    "all",
    "would",
    "there",
    "their",
    "what",
    "so",
    "up",
    "out",
    "if",
    "about",
    "who",
    "get",
    "which",
    "go",
    "me",
    "when",
    "make",
    "can",
    "like",
    "time",
    "no",
    "just",
    "him",
    "know",
    "take",
    "people",
    "into",
    "year",
    "your",
    "good",
    "some",
    "could",
    "them",
    "see",
    "other",
    "than",
    "then",
    "now",
    "look",
    "only",
    "come",
    "its",
    "over",
    "think",
    "also",
    "back",
    "after",
    "use",
    "two",
    "how",
    "our",
    "work",
    "first",
    "well",
    "way",
    "even",
    "new",
    "want",
    "because",
    "any",
    "these",
    "give",
    "day",
    "most",
    "us",
    "is",
    "was",
    "are",
    "been",
    "has",
    "had",
    "were",
    "said",
    "did",
    "having",
    "python",
    "programming",
    "computer",
    "software",
    "code",
    "data",
    "algorithm",
    "function",
    "variable",
    "string",
    "integer",
    "list",
    "dictionary",
    "class",
    "object",
    "method",
    "performance",
    "optimization",
    "benchmark",
    "speed",
    "efficiency",
    "memory",
    "process",
]


def generate_text_file(filename, target_size_gb=1.0):
    target_bytes = int(target_size_gb * 1024 * 1024 * 1024)
    bytes_written = 0
    words_per_line = 15

    print(f"Generating {target_size_gb}GB text file: {filename}")
    print("This may take a few minutes...")

    with open(filename, "w") as f:
        while bytes_written < target_bytes:
            line = " ".join(random.choices(WORDS, k=words_per_line)) + "\n"
            f.write(line)
            bytes_written += len(line)

            if bytes_written % (100 * 1024 * 1024) == 0:
                progress = (bytes_written / target_bytes) * 100
                print(
                    f"Progress: {progress:.1f}% ({bytes_written / (1024*1024):.0f} MB)"
                )

    final_size_mb = bytes_written / (1024 * 1024)
    final_size_gb = bytes_written / (1024 * 1024 * 1024)
    print(f"\nGenerated file: {filename}")
    print(f"Size: {final_size_mb:.2f} MB ({final_size_gb:.3f} GB)")
    print(f"Approximate lines: {bytes_written // (words_per_line * 5)}")


if __name__ == "__main__":
    size_gb = float(sys.argv[1]) if len(sys.argv) > 1 else 1.0
    output_file = sys.argv[2] if len(sys.argv) > 2 else "benchmark/data/sample.txt"
    generate_text_file(output_file, size_gb)
