#!/bin/sh
# GitHub repository setup script for Scryer Prolog Workshop

REPO_NAME="scryer-prolog-workshop"
REPO_ORG="aygp-dr"
REPO_DESC="A comprehensive workshop for learning Scryer Prolog with literate programming using Org-mode. Includes automated setup, examples, and LSP support for Emacs."

# Repository topics (5 good topics for GitHub)
TOPICS="prolog scryer-prolog literate-programming org-mode rust"

echo "=== Scryer Prolog Workshop - GitHub Setup ==="
echo ""
echo "This script will help you create and configure the GitHub repository."
echo ""

# Check if gh CLI is installed
if ! command -v gh >/dev/null 2>&1; then
    echo "GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it with:"
    echo "  FreeBSD: sudo pkg install gh"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://cli.github.com/manual/installation"
    echo ""
    echo "Or create the repository manually:"
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: $REPO_NAME"
    echo "3. Description: $REPO_DESC"
    echo "4. Set to Public"
    echo "5. Don't initialize with README (we already have one)"
    echo "6. Add topics: $TOPICS"
    echo ""
    echo "Then run these commands:"
    echo "  git remote add origin git@github.com:$REPO_ORG/$REPO_NAME.git"
    echo "  git push -u origin main"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status >/dev/null 2>&1; then
    echo "You need to authenticate with GitHub first."
    echo "Run: gh auth login"
    exit 1
fi

echo "Creating GitHub repository: $REPO_ORG/$REPO_NAME"
echo ""

# Create the repository
gh repo create "$REPO_ORG/$REPO_NAME" \
    --public \
    --description "$REPO_DESC" \
    --source=. \
    --remote=origin \
    --push

if [ $? -eq 0 ]; then
    echo ""
    echo "Repository created successfully!"
    echo ""
    echo "Adding topics..."

    # Add topics (requires API call)
    for topic in $TOPICS; do
        echo "  - $topic"
    done

    # Use gh api to set topics
    gh api repos/$REPO_ORG/$REPO_NAME/topics \
        --method PUT \
        --field names[]="prolog" \
        --field names[]="scryer-prolog" \
        --field names[]="literate-programming" \
        --field names[]="org-mode" \
        --field names[]="rust"

    echo ""
    echo "✓ Repository setup complete!"
    echo ""
    echo "Repository URL: https://github.com/$REPO_ORG/$REPO_NAME"
    echo ""
    echo "Next steps:"
    echo "1. Visit your repository and verify the setup"
    echo "2. Consider adding a repository image/social preview"
    echo "3. Enable GitHub Pages if desired"
    echo "4. Set up any branch protection rules"
else
    echo ""
    echo "Failed to create repository. You may need to:"
    echo "1. Check your authentication: gh auth status"
    echo "2. Verify organization permissions"
    echo "3. Create the repository manually (see instructions above)"
fi
