# functions in this file are rarely used but they have their advantage, therefore keep them when needed
# uncomment when needed to run

#if [ -x "$(command -v ffmpeg)" ]; then
   _ffmpeg_add_sub_to_video() {
       # adds the subtitles to the video as a separate optional (and user-controlled) subtitle track.
       # create new video with embedded subtitle
       #https://stackoverflow.com/a/33289845/1530178
       # only support mkv video and srt sub

       local video="$1"
       local sub="$2"
       local videoName=$(basename $video | cut -d '.' -f1)
       local videoExtension=$(basename $video | cut -d '.' -f2)

       # this will add an additional subtitle with metadata 'unknown'
       ffmpeg -i $video -i $sub \
           -map 0:0 -map 0:1 -map 1:0 \
           -c:v copy -c:a copy -c:s srt \
           "${videoName}_formatted.$videoExtension"

       # to add multiple subtitles with proper metadata use below script instead. Note that it is intended to run manually
       # ffmpeg -i $video -i $sub1 -i$sub2 ... \
       #     -map 0:v -map 0:a -map 1 -map 2 \
       #     -c:v copy -c:a copy -c:s srt \
       #     -metadata:s:s:0 language=$lang1 -metadata:s:s:1 language=$lang2 ...\
       #     "${videoName}_formatted.$videoExtension"
   }

   _ffmpeg_add_hard_ass_sub_to_mp4_video() {
       # can use aegisub to config subtitle style or convert srt file
       local video="$1"
       local sub="$2"
       local videoName=$(basename $video | cut -d '.' -f1)
       local videoExtension=$(basename $video | cut -d '.' -f2)

       ffmpeg -i $video -vf ass=$sub "${videoName}_formatted.$videoExtension"
   }

#    _ffmpeg_add_sub_to_mp4_video() {
#        # adds the subtitles to the video as a separate optional (and user-controlled) subtitle track.
#        # create new video with embedded subtitle
#        #https://stackoverflow.com/a/33289845/1530178
#        # only support mkv video and srt sub

#        local video="$1"
#        local sub="$2"
#        local videoName=$(basename $video | cut -d '.' -f1)
#        local videoExtension=$(basename $video | cut -d '.' -f2)

#        # this will add an additional subtitle with metadata 'unknown'
#        ffmpeg -i $video -i $sub \
#            -map 0:0 -map 0:1 -map 1:0 \
#            -c:v copy -c:a copy -c:s mov_text \
#            "${videoName}_formatted.$videoExtension"

#        # to add multiple subtitles with proper metadata use below script instead. Note that it is intended to run manually
#        # ffmpeg -i $video -i $sub1 -i$sub2 ... \
#        #     -map 0:v -map 0:a -map 1 -map 2 \
#        #     -c:v copy -c:a copy -c:s srt \
#        #     -metadata:s:s:0 language=$lang1 -metadata:s:s:1 language=$lang2 ...\
#        #     "${videoName}_formatted.$videoExtension"
#    }

#    _ffmpeg_cut_video() {
#        local video="$1"
#        local videoName=$(basename $video | cut -d '.' -f1)
#        local videoExtension=$(basename $video | cut -d '.' -f2)
#        local outputVideo="${videoName}_cut.$videoExtension"

#        local from="$2" # ex: 00:01:16.500
#        local to="$3" # ex: 00:01:16.500

#        ffmpeg -i $video -ss $from -to $to -c:v copy -c:a copy $outputVideo
#    }
#fi

# if [ -x "$(command -v shnsplit)" ]; then
#     _splitFlac() {
#         [ -z "$1" ] && { echo  "missing cue file"; exit 1; }
#         [ -z "$2" ] && { echo  "missing flac file"; exit 1; }

#         local cueFile="$1"
#         local flacFile="$2"

#         shnsplit -f $cueFile -t %t-%p-%a -o flac $flacFile
#     }
# fi

# if [ -x "$(command -v ffmpeg)" ]; then
#     _vtt_to_srt() {
#         local file="$1"

#         ffmpeg -i $file "$(basename $file .srt)"
#     }
# fi

# if [ -x "$(command -v youtube-dl)" ]; then
    _youtube_download_video_mkv() {
        # download youtube video as mkv
        local url="$1"
            # youtube video url. ex: https://www.youtube.com/watch?v=LQRAfJyEsko

        youtube-dl \
            --format 'bestvideo[height=1080]+bestaudio' \
            --write-sub --sub-lang en,en_US,en_GB,en-US,en-GB \
            --merge-output-format mkv --embed-sub \
            -o '%(title)s.%(ext)s' \
            $url
    }

    _youtube_download_sub() {
        # download youtube video subtitle only
        local url="$1"
        local subLanguage="${2:-en,en_US,en_GB,en-US,en-GB}" # default to download english sub

        youtube-dl \
            --write-sub --sub-lang $subLanguage \
            --skip-download \
            $url
    }
# fi


# if [ -x "$(command -v gcloud)" ]; then
    # _gcp_log_kevent() {
    #     # Example
    #     # _gcp_log_event_hpa \
    #     #     "jsonPayload.involvedObject.name=<project_name>" \
    #     #     "timestamp>=\"$(date --iso-8601=s --date='7 days ago')\""
    #     local filter=(
    #         "resource.type=gke_cluster"
    #         "jsonPayload.kind=Event"
    #         # "timestamp>=\"$(date --iso-8601=s --date='30 minutes ago')\"" # latest 30 minutes
    #         # "jsonPayload.source.component=horizontal-pod-autoscaler"
    #         # "severity=WARNING" # check for specific severity
    #         # "resource.labels.cluster_name=vexere"
    #         # "jsonPayload.metadata.name:<pod_name>" # check specific pod pattern
    #         # "jsonPayload.reason=FailedGetResourceMetric" # check for specific reason
    #         "$@"
    #     )
    #     local filterStr=$( _join_by ' ' "${filter[@]}" )

    #     local resultField=(
    #         "'resource.labels.cluster_name'"
    #         # "'resource.labels.location'"
    #         # "'resource.labels.project_id'"
    #         # "'resource.type'"
    #         "'jsonPayload.involvedObject.namespace'"
    #         "'jsonPayload.involvedObject.kind'"
    #         "'jsonPayload.involvedObject.name'"
    #         # "'jsonPayload.metadata.name'"
    #         "'jsonPayload.reason'"
    #         "'jsonPayload.message'"
    #         "'severity'"
    #         "'timestamp'"
    #         "'kind'"
    #     )
    #     local resultFieldStr=$(_join_by ',' "${resultField[@]}")

    #     gcloud logging read "$filterStr" --limit 9000 --format json \
    #     | fx ".map( x => [$resultFieldStr].reduce( (acc,cur) => { acc[cur] = require('lodash').get(x, cur); return acc }, {} ))"
    # }

    # _gcp_log_event_hpa() {
    #     _gcp_log_kevent "jsonPayload.source.component=horizontal-pod-autoscaler" "$@"
    # }

    # _gcp_service_account_iam_policy() {
    #     [ -z "$1" ] && { echo "missing serviceAccount argument"; exit 1; }
    #     local serviceAccount="$1"

    #     gcloud projects get-iam-policy $GCP_PROJECT_ID  \
    #     --flatten="bindings[].members" \
    #     --format='table(bindings.role)' \
    #     --filter="bindings.members:$serviceAccount"
    # }
# fi
