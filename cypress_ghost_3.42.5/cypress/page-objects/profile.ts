import * as cypress from "cypress";

export class Profile {
  newPassword: string;
  goToProfile() {
    cy.log(`#/staff/${Cypress.env("username").split(" ")[0].toLowerCase()}/`);
    cy.visit(
      Cypress.env("url") +
        `/ghost/#/staff/${Cypress.env("username").split(" ")[0].toLowerCase()}`
    );
    return this;
  }

  fillOldPassword(password: string) {
    cy.get("#user-password-old").type(password);
    return this;
  }

  fillNewPassword(newPassword: string) {
    cy.get("#user-password-new").type(newPassword);
    this.newPassword = newPassword;
    return this;
  }

  fillVerifyNewPassword() {
    cy.get("#user-new-password-verification").type(this.newPassword);
    return this;
  }

  clickChangePassword() {
    cy.contains("Change Password").click();
    return this;
  }

  clickSignOut() {
    cy.get('[data-ebd-id="ember26-trigger"]').click();
    cy.get('[href="#/signout/"]').click({ force: true });
    return this;
  }
}
