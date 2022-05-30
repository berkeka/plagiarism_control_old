import { Controller } from "@hotwired/stimulus"
import hljs from "highlight.js"

export default class extends Controller {
  static values = { url: String }
  static targets = ['table', 'button', 'codes', 'codeBlock']

  connect() {
    fetch(this.urlValue, { headers: { accept: "application/json" } })
        .then((response) => response.json())
        .then((data) => {
            this.files = data['files'];
            this.language = data['language'];
        });
  }

  details(event) {
    const targetNode = event.target.parentNode;
    
    const firstID = parseInt(targetNode.children[1].innerHTML);
    const secondID = parseInt(targetNode.children[3].innerHTML);

    this.codeBlockTargets[0].classList.add(`language-${this.language}`);
    this.codeBlockTargets[1].classList.add(`language-${this.language}`);

    this.setInvisible(this.tableTarget);
    this.setVisible(this.buttonTarget);
    this.setVisible(this.codesTarget);

    this.codeBlockTargets[0].innerHTML = this.files[firstID];
    this.codeBlockTargets[1].innerHTML = this.files[secondID];
    hljs.highlightAll();
  }

  back() {
    // Reset code block class to hljs
    this.codeBlockTargets[0].className = 'hljs';
    this.codeBlockTargets[1].className = 'hljs';

    // Make visibility changes
    this.setInvisible(this.buttonTarget);
    this.setInvisible(this.codesTarget);
    this.setVisible(this.tableTarget);
  }

  setVisible(element) {
    element.classList.remove('hidden');
    element.classList.add('inline');
  }

  setInvisible(element) {
    element.classList.remove('inline');
    element.classList.add('hidden');
  }
}
