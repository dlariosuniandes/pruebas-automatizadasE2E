import * as cypress from "cypress";
import { getSyntheticLeadingComments } from "typescript";

export class PostPage {
  checkIfComponentExists(): Cypress.Chainable<boolean> {
    return cy.get(".post-header").then((selectedElement) => {
      if (selectedElement) return true;
      return false;
    });
  }
  clickNewPost() {
    cy.contains("New post").click();
    return this;
  }

  fillTitle(title: string) {
    cy.get('[placeholder="Post Title"]').type(`${title}{enter}`, {
      waitForAnimations: true,
    });
    return this;
  }

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
    cy.contains("Delete").click();
    return this;
  }

  confirmDelete() {
    cy.get(".modal-footer").children("button.gh-btn-red").first().click();
    return this;
  }

  goToPostSettings() {
    cy.get('[title="Settings"]').click();
    return this;
  }

  selectTag(tagName: string) {
    cy.get("input.ember-power-select-trigger-multiple-input")
      .first()
      .type(`${tagName}{enter}`)
      .wait(2000);
    return this;
  }

  confirmLeave() {
    cy.get(".modal-footer").children("button.gh-btn-red").first().click();
    return this;
  }

  clickPublish() {
    cy.contains("Publish").click();
    cy.get(".gh-publishmenu-button").click();
    return this;
  }

  clickUnpublish() {
    cy.get(".gh-publishmenu").click();
    cy.get(".gh-publishmenu-radio").contains("Unpublished").click();
    cy.get(
      "button.gh-btn.gh-btn-blue.gh-publishmenu-button.gh-btn-icon.ember-view"
    ).click();
    return this;
  }
}
