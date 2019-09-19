if isServiceExist gcloud; then

    alias g_compute="_g_compute"
    alias g_sql="_g_sql"
    alias g_service="_g_service"

    _g_compute() {
        local instance
        if isServiceExist fzf; then
            instance=$(gcloud compute instances list | fzf | awk '{print $1}')
        else
            gcloud compute instances list && return
        fi

        # if variable is set and not empty https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
        if [ -n "${instance:+1}" ]; then
            gcloud compute instances describe $instance
        fi
    }

    _g_sql() {
        local instance
        if isServiceExist fzf; then
            instance=$(gcloud sql instances list | fzf | awk '{print $1}')
        else
            gcloud sql instances list && return
        fi

        if [ -n "${instance:+1}" ]; then
            gcloud sql instances describe $instance
        fi
    }

    _g_service() {
        if isServiceExist fzf; then
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)' | fzf
        else
            gcloud services list --format='table(config.name,config.title,config.documentation.summary)'
        fi

    }

fi
