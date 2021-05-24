export class SettingsPage {
  expandTitleAndDescription() {
    cy.contains("Expand").first().click({ force: true });
    return this;
  }

  fillNameSite(name: string) {
    cy.get("input").first().type(name, {force: true});
    return this;
  }

  saveSettings() {
    cy.contains("Save settings").click();
    return this;
  }
}
