import * as cypress from "cypress";
import { getSyntheticLeadingComments } from "typescript";

export class PagePage {
  checkIfComponentExists(): Cypress.Chainable<boolean> {
    return cy.get(".post-header").then((selectedElement) => {
      if (selectedElement) return true;
      return false;
    });
  }
  clickNewPost() {
    cy.contains("New page").click();
    return this;
  }

  fillTitle(title: string) {
    cy.get('[placeholder="Page Title"]').type(`${title}{enter}`, {
      waitForAnimations: true,
    });
    return this;
  }

  // Causes webpack compilation error
  fillContent() {
    cy.get("article").click();
    cy.get("body").type("test");
    return this;
  }

  clickBack() {
    cy.go("back");
    return this;
  }

  clickDelete() {
    cy.contains("Delete page").click();
    return this;
  }

  confirmDelete() {
    cy.get(".modal-footer").children("button.gh-btn-red").first().click();
  }
}
