import * as cypress from "cypress";
import { getSyntheticLeadingComments } from "typescript";

export class TagPage {
  checkIfComponentExists(): Cypress.Chainable<boolean> {
    return cy.get(".tags-header").then((selectedElement) => {
      if (selectedElement) return true;
      return false;
    });
  }
  clickNewTag() {
    cy.contains("New tag").click();
    return this;
  }

  fillTagName(title: string) {
    cy.get('#tag-name').type(`${title}`, {
      force: true,
    })
    return this;
  }

  saveTag(){
      cy.contains("Save").click()
      return this
  }

  clickBack() {
    cy.go("back")
    return this;
  }

  clickDelete() {
    cy.contains("Delete").click()
    return this
  }

  confirmDelete() {
    cy.get('.modal-footer').children('button.gh-btn-red').first().click()
  }
}
