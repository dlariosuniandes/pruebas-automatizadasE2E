import * as cypress from "cypress";
//@ts-check
/// <reference types="cypress-xpath" />

export class Staff {
  clickInvite() {
    cy.xpath(
      `//button[@class="gh-btn gh-btn-green"]//span[text()="Invite people"]`
    ).click({ force: true });
    return this;
  }

  fillEmail(email: string) {
    cy.xpath(`//input[@id="new-user-email"]`).first().type(email);
  }

  clickSend() {
    cy.xpath(
      `//button[@class="gh-btn gh-btn-green gh-btn-icon ember-view"]//span[text()="Send invitation now"]`
    ).click({ force: true });
  }

  revokeInvite(email: string){
    cy.xpath(
        `//h3[text()="${email}"]/../../..//a[@href="#revoke"]`
      ).click({ force: true });
  }
}
