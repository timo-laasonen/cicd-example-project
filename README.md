# cicd-pipeline-train-schedule-git

This is a simple train schedule app written using nodejs. It is intended to be used as a sample application for a series of hands-on learning activities.

## Running the app

It is not necessary to run this app locally in order to complete the learning activities, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:3000](http://localhost:3000)

Using localhost Jenkins running on Docker and this repository has webhook configured with Jenkins. With localhost setup localtunnel (https://www.npmjs.com/package/localtunnel) is needed that GitHub can access locally running Jenkins. 

Github repository must be public in order to get Jenkins webhooks to work
