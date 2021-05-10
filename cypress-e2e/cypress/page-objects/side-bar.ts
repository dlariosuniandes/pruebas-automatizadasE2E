import * as cypress from "cypress";

export class SideBar {

  checkIfComponentExists(): Cypress.Chainable<boolean> {
    return cy.get("#ember24").then((selectedElement) => {
      if (selectedElement) return true;
      return false;
    });
  }

  goToPosts() {
    cy.get('a[href="#/posts/"]').first().click()
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
    cy.get('a[href=#/settings/general/]').click();
    return this;
  }

  goToDesignSettings() {
    cy.get('a[href=#/settings/design/]').click();
    return this;
  }

  goToCodeInjectionSite() {
    cy.get('a[href=#/settings/code-injection/]').click();
    return this;
  }

}
