import * as cypress from "cypress";

export class SideBar {
  checkIfComponentExists(): Cypress.Chainable<boolean> {
    return cy.get("#ember24").then((selectedElement) => {
      if (selectedElement) return true;
      return false;
    });
  }

  goToPosts() {
    cy.get('a[href="#/posts/"]').first().click();
    return this;
  }
  goToPages() {
    cy.get('a[href="#/pages/"]').click();
    return this;
  }

  goToTags() {
    cy.get('a[href="#/tags/"]').click();
    return this;
  }

  goToGeneralSettings() {
    cy.get('a[href="#/settings/general/"]').click();
    return this;
  }

  goToDesignSettings() {
    cy.get('a[href="#/settings/design/"]').click();
    return this;
  }

  goToStaff() {
    cy.get('a[href="#/staff/"]').first().click();
    return this;
  }

  goToCodeInjectionSite() {
    cy.get('a[href="#/settings/code-injection/"]').click();
    return this;
  }

  goToSite() {
    cy.contains(" View site ").click();
  }

  goToSearch() {
    cy.get('[title="Search site (Ctrl/⌘ + K)"]').click({ force: true });
  }

  typeSearch(value: string) {
    cy.get('[placeholder="Search site..."]')
      .first()
      .type(value, { force: true });
  }

  logout(){
    cy.xpath(`//span[@title="${Cypress.env('username')}"]`).click({ force: true })
    cy.xpath(`//li[@role="presentation"]//a[@class="dropdown-item user-menu-signout ember-view"]`).click({ force: true })
  }
}
