export class CodeInjection {
    addHeader(value:string) {
      cy.get('.CodeMirror-scroll').first().type(`<div class="${value}"></div>`)
      return this;
    }
  
    saveChanges() {
      cy.contains("Save").first().click({force: true});
      return this;
    }
  
  }