import requests
import json
from datetime import datetime

# Jira Configuration
JIRA_BASE_URL = "https://yourcompany.atlassian.net"
JIRA_API_USER = "your-email@example.com"
JIRA_API_TOKEN = "your-api-token"
JIRA_PROJECT = "APPX"
JIRA_HEADERS = {
    "Content-Type": "application/json",
    "Authorization": f"Basic {requests.auth._basic_auth_str(JIRA_API_USER, JIRA_API_TOKEN)}"
}

# Squad Mapping (Example: Team A, Team B)
SQUADS = {
    "Team A": "project = APPX AND assignee in (team_a_members)",
    "Team B": "project = APPX AND assignee in (team_b_members)",
}

# Jira JQL Queries
BLOCKED_ISSUES_QUERY = f"project = {JIRA_PROJECT} AND status = 'Blocked'"
DEPENDENCIES_QUERY = f"project = {JIRA_PROJECT} AND issueType = 'Dependency' AND status != 'Resolved'"

def fetch_jira_issues(jql_query):
    """Fetch issues from Jira using JQL"""
    url = f"{JIRA_BASE_URL}/rest/api/3/search"
    params = {"jql": jql_query, "maxResults": 50}
    response = requests.get(url, headers=JIRA_HEADERS, params=params)

    if response.status_code == 200:
        return response.json()["issues"]
    else:
        print(f"❌ Error fetching Jira issues: {response.status_code} - {response.text}")
        return []

def generate_report():
    """Generate a report for squads, blocked issues, and dependencies"""
    report = {}
    
    # Get squad issues
    for squad, jql in SQUADS.items():
        issues = fetch_jira_issues(jql)
        report[squad] = len(issues)
    
    # Get blocked issues
    blocked_issues = fetch_jira_issues(BLOCKED_ISSUES_QUERY)
    report["Blocked Issues"] = len(blocked_issues)

    # Get cross-team dependencies
    dependencies = fetch_jira_issues(DEPENDENCIES_QUERY)
    report["Unresolved Dependencies"] = len(dependencies)

    return report

def display_report():
    """Print the report"""
    report = generate_report()
    print("\n🚀 **Jira Auto Report** -", datetime.now().strftime("%Y-%m-%d %H:%M"))
    print("=" * 50)
    
    for key, value in report.items():
        print(f"{key}: {value}")

    print("=" * 50)

# Run the script
if __name__ == "__main__":
    display_report()

