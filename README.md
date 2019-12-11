# Final project for getting and cleaning data course
# In the script, we load the libraries used (dplyr and data.table)
# Then we create a directory for our dataset if one does not yet exist
# We then download and unzip the dataset files
# We read the tables and set them to our variables
#    activity_labels 
#    feature_names  
#    subject_test 
#    features_test 
#    activity_test 
#    subject_train 
#    features_train 
#    activity_train 
# After that we merge the matching datasets between activities, features, and subjects
# We then set the column names for the data sets
# After that we merge/bind everything together to get one dataset called merged_dataset
# We then extract only the measurements for mean and std dev for each measurement
# We take these names in order to filter down our dataset which then gives us mean_std_dev
# From there, by looking at the dataset we can see the substitutions we can make to give descriptive activity names
# Then we take our current dataset and aggregate it to get the mean for each variable and order it by Subject and then Activity
# Finally, we write the table into a txt file, which I have named TidyData.txt
