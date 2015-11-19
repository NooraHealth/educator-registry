Template.editPatient.events
  "click #save_patient": ()->
    console.log "Clicked submit"
    patientName = $("input[name=patient_name]").val()
    attender = $("input[name=attender_name]").val()
    phone = $("input[name=phone]").val()
    lang = $("input[name=language]:checked").val()
    subscribe = $("input[name=subscribe]").is ":checked"
    isTest = Meteor.settings.public.isDevMode
    date = moment().toDate()

    patient = {
      name: patientName
      attender: attender
      phone: phone
      language: lang
      subscribes_to_ivr: subscribe
      has_been_input_to_ivr_system: false
      took_first_class: false
      took_practical: false
      discharged: false
      date_added: date
      date_discharged: null
      date_first_class: null
      date_practical: null
      hospital: "Jayadeva"
      test: isTest
    }

    Meteor.call "insertPatient", patient

    analytics.track "Action", {
      location: "newPatient",
      text: "submit",
      color: "blue"
    }

    console.log Patients.findOne { _id: patient}

