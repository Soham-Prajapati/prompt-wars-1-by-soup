import re

with open('README.md', 'r') as f:
    text = f.read()

# Remove PDF headers/footers
text = re.sub(r'CONFIDENTIAL — INTERNAL USE ONLY\n', '', text)
text = re.sub(r'StadiumIQ · PRD v1\.0 · Page \d+\n', '', text)

# Fix broken bullet points and lines
# This is tricky without knowing exact structure, but we can fix multiple newlines
text = re.sub(r'\n{3,}', '\n\n', text)

with open('README.md', 'w') as f:
    f.write(text)
