Template.trackPatients.helpers
  discharged: ()->
    search = Session.get "search_query"
    re = new RegExp search
    #return Patients.find {$or: [{ name: { $regex: re }, phone: { $regex: re }, condition: { $regex: re} }]  }
    return Patients.find { $or:[ {phone: {$regex: re}}], $and: [{ date_discharged: {$not: null} } ] } , { $sort: { name: -1 }}

  patients: ()->
    search = Session.get "search_query"
    re = new RegExp search
    return Patients.find {$or: [ {name: { $regex: re } }, {phone: {$regex: re}}, {condition: { $regex: re }}] , $and: [{ date_discharged: null }] } , { $sort: { name: -1 }}

Template.trackPatients.onRendered ()->
  analytics.trackLink $("#active-tab"), "click", {name: "active-tab"}
  analytics.trackLink $("#discharged-tab"), "click", {name: "discharged-tab"}
  analytics.trackLink $("#back-button"), "click", {name: "back-button"}

Template.trackPatients.events
  "keyup #search": ( e )->
    analytics.track "Used Search", {
      location: "trackPatients"
    }

    search = $("#search").val()
    Session.set "search_query", search

  "change input[name=subscribed]": ( e )->
    console.log "Changed the subscribed value"
    analytics.track "click", {
      location: "trackPatients",
      text: "subscribed"
    }
    subscribed = $(e.target).is ":checked"
    Patients.update { _id: @._id }, { $set: { subscribes_to_ivr: subscribed }}
    Meteor.call "updatePatient", { Id: @.salesforce_id, "Subscribed_to_IVR__c": subscribed }

  "change input[name=took_practical]": ( e )->
    console.log "Practical checked"
    console.log @
    analytics.track "click", {
      location: "trackPatients",
      text: "took_practical"
    }
    tookPractical = $(e.target).is ":checked"
    console.log "Took practical?", tookPractical
    if tookPractical
      date = moment().toDate()
    else
      date = null
    Patients.update { _id: @._id }, { $set: { date_practical: date}}
    Meteor.call "updatePatient", { Id: @.salesforce_id, "Date_took_practical__c" : date }

  "change input[name=discharged]": ( e )->
    console.log "Discharged checked"
    console.log @
    analytics.track "click", {
      location: "trackPatients",
      text: "discharged"
    }
    discharged = $(e.target).is ":checked"
    id = $(e.target).find("form").attr "id"
    if discharged
      date = moment().toDate()
    else
      date = null
    Patients.update { _id: @._id }, { $set: { date_discharged: date }}
    Meteor.call "updatePatient", { Id: @.salesforce_id, "Date_discharged__c" : date }

  "change input[name=took_first_class]": ( e )->
    console.log "Took First Class checked"
    console.log @
    analytics.track "click", {
      location: "trackPatients",
      text: "took_first_class"
    }
    tookClass = $(e.target).is ":checked"
    if tookClass
      date = moment().toDate()
    else
      date = null
    Patients.update { _id: @._id }, { $set: { date_first_class: date } }
    Meteor.call "updatePatient", { Id: @.salesforce_id, "Date_first_class__c" : date }

Template.patientInfo.helpers
  isTrue: ( query )->
    patient = Template.currentData()
    if query == "subscribes_to_ivr"
      return patient["subscribes_to_ivr"] == true
    if query == "discharged"
      return patient["date_discharged"] != null
    if query == "took_practical"
      return patient["date_practical"] != null
    if query == "took_first_class"
      return patient["date_first_class"] != null
    else
      return false
