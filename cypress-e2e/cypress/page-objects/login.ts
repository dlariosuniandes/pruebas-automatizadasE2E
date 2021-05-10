import * as cypress from "cypress";

export class Login {
  visit() {
    cy.visit(Cypress.env('url') + "/ghost/#/signin")
    return this
  }
  fillPassword() {
    cy.get("[name=password]").type(Cypress.env('password'));
    return this;
  }

  fillNewPassword(password:string) {
    cy.get("[name=password]").type(password);
    return this;
  }

  fillEmail() {
    cy.get("[name=identification]").type(Cypress.env('user'))
    return this;
  }
  clickLoginButton(){
      cy.contains("Sign in").click()
  }

  loginWithEnvUser(){
    this.fillEmail()
    this.fillPassword()
    this.clickLoginButton();
  }

  loginWithNewPassword(password: string){
    this.fillEmail()
    this.fillNewPassword(password)
    this.clickLoginButton();
  }
}
