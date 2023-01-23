module Page.EditPost exposing (Model)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode
import Post exposing (Post, PostId, postDecoder)
import RemoteData exposing (WebData)


type alias Model =
    { navKey : Nav.Key
    , post : WebData Post
    }


init : PostId -> Nav.Key -> ( Model, Cmd Msg )
init postId navKey =
    ( initialModel navKey, fetchPost postId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , post = RemoteData.Loading
    }


fetchPost : PostId -> Cmd Msg
fetchPost postId =
    Http.get
        { url = "http://localhost:5019/posts/" ++ Post.idToString postId
        , expect =
            postDecoder
                |> Http.expectJson (RemoteData.fromResult >> PostReceived)
        }


type Msg
    = PostReceived (WebData Post)
    | UpdateTitle String
    | UpdateAuthorName String
    | UpdateAuthorUrl String
    | SavePost


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PostReceived post ->
            ( { model | post = post }, Cmd.none )

        UpdateTitle newTitle ->
            let
                updateTitle =
                    RemoteData.map
                        (\postData ->
                            { postData | title = newTitle }
                        )
            in
            ( { model | post = updateTitle }, Cmd.none )

        UpdateAuthorName newName ->
            let
                updateAuthorName =
                    RemoteData.map
                        (\postData ->
                            { postData | authorName = newName }
                        )
                        model.post
            in
            ( { model | post = UpdateAuthorName }, Cmd.none )

        UpdateAuthorUrl newUrl ->
            let
                updateAuthorUrl =
                    RemoteData.map
                        (\postData ->
                            { postData | authorUrl = newUrl }
                        )
                        model.post
            in
            ( { model | post = updateAuthorUrl }, Cmd.none )

        SavePost ->
            ( model, savePost model.post )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Edit Post" ]
        , viewPost model.post
        ]


viewPost : WebData Post -> Html Msg
viewPost post =
    case post of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading Post..." ]

        RemoteData.Success postData ->
            editForm postData

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


editForm : Post -> Html Msg
editForm post =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value post.title
                , onInput UpdateTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorName
                , onInput updateAuthorName
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Url"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorUrl
                , onInput UpdateAuthorUrl
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick SavePost ]
                [ text "Submit" ]
            ]
        ]


viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch post at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


savePost : WebData Post -> Cmd Msg
savePost post =
    case post of
        RemoteData.Success postData ->
            let
                postUrl =
                    "http://localhost:5019/posts/"
                        ++ Post.idToString postData.id
            in
            Http.request
                { method = "PATCH"
                , headers = []
                , url = postUrl
                , body = Http.jsonBody (postEncoder postData)
                , expect = Http.expectJson PostSaved postDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none


postEncoder : Post -> Encode.Value
postEncoder post =
    Encode.object
        [ ( "id", encodeId post.id )
        , ( "title", Encode.string post.title )
        , ( "authorName", Encode.string post.authorName )
        , ( " authorUrl", Encode.string post.authorUrl )
        ]


encodeId : PostId -> Encode.Value
encodeId (PostId id) =
    Encode.int id
