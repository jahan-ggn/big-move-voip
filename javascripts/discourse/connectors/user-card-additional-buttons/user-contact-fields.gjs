import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import EmberObject, { set } from "@ember/object";
import { service } from "@ember/service";
import { dasherize } from "@ember/string";
import { isEmpty } from "@ember/utils";
import { eq } from "truth-helpers";

export default class UserContactFields extends Component {
  @service site;

  get userFields() {
    return this.args.user.user_fields;
  }

  get userDetails() {
    const siteUserFields = this.site.get("user_fields");

    if (!isEmpty(siteUserFields)) {
      const userFields = this.userFields;
      return siteUserFields
        .filter((field) => {
          const name = field.get("name");
          return name === "Mobilfunknummer" || name === "Festnetz-Nummer";
        })
        .sortBy("position")
        .map((field) => {
          set(field, "dasherized_name", dasherize(field.get("name")));
          const value = userFields ? userFields[field.get("id")] : null;
          return isEmpty(value) ? null : EmberObject.create({ value, field });
        })
        .compact();
    }
    return [];
  }

  <template>
    {{#each this.userDetails as |detail|}}
      <li class={{concat detail.field.name}}>
        <a
          href={{concat "tel:" detail.value}}
          class="btn btn-primary"
          style="width:100%;"
        >
          <svg class="svg-icon" style="margin-right: 0.5em;"><use
              xlink:href={{if
                (eq detail.field.name "Mobilfunknummer")
                "#mobile-screen"
                "#phone"
              }}
            ></use></svg>
          {{detail.field.name}}
        </a>
      </li>
    {{/each}}
  </template>
}
