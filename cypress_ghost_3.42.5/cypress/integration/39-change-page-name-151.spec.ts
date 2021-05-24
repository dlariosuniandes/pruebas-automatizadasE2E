import { Login } from "../page-objects/login";
import { SideBar } from "../page-objects/side-bar";
import { SettingsPage } from "../page-objects/settings-page";
import * as faker from "faker";
import { should } from "chai";
const login = new Login();
const sideBar = new SideBar();
const settingsPage = new SettingsPage();

const cookieSessionName =
  Cypress.env("cookieSessionName") || "ghost-admin-api-session";

describe("Should login and create a post with title succesfully", () => {
  Cypress.on("uncaught:exception", (err, runnable) => {
    // returning false here prevents Cypress from
    // failing the test
    return false;
  });

  //const newTitle = faker.lorem.words();
  let tempURL: string;

  let datetime;
  let newTitle;
  before(() => {
    datetime = new Date().toISOString().replace(/:/g, ".");
    cy.request(
        {
            method : 'GET',
            url : 'https://my.api.mockaroo.com/site_config.json?key=872fc0c0',
            headers : {
                'content-type' : 'application/json'
            },
            body : {
                'newTitle' : 'site_name_151'
            }
        }).then((response)  => {
            expect(response).property('status').to.equal(200)
            expect(response.body).property('site_name_151').to.not.be.oneOf([null, ""])
            const body = (response.body)
            newTitle = body['site_name_151']
        });
  });

  beforeEach(() => {
    Cypress.Cookies.preserveOnce(cookieSessionName);
  });

  it("should login the user", () => {
    login.visit();
    login.loginWithEnvUser();
    cy.url().should("include", "/#/site");
    cy.screenshot(`${datetime}/image-1`);
  });

  it("should go to settings", () => {
    if (sideBar.checkIfComponentExists()) {
      cy.log("theres sidebar");
      sideBar.goToGeneralSettings();
      cy.screenshot(`${datetime}/image-2`);
    }
  });

  it("should change name of the website", () => {
    settingsPage
      .expandTitleAndDescription()
      cy.screenshot(`${datetime}/image-3`);
      settingsPage
      .fillNameSite(newTitle)
      .saveSettings();
  });

  it("should go to site", () => {
    sideBar.goToSite();
    cy.screenshot(`${datetime}/image-4`);
  });

});
