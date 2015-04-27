## Repositories we explored
1. bighero4/MarkParser
2. SuperCh-SE-NCSU/ProjectScraping
3. CSC510/SQLvsNOSQL

## Features & Bad smells(Extractor & Results) 

**1. Uneven Commit History**

- __Feature Detection__
    
    In this feature extractor we aim to find anamolous behaviour or irregular commits on week by week basis. We would analyse the number of commits per week. The code for data collection can be found here [scraper.rb](features/uneven_commits/scraper.rb)

- __Feature detection results__
    
    Inorder to create the above feature we need the commit 'sha' and the 'timestamp' attributes. We have used [commits](https://developer.github.com/v3/repos/commits/) API endpoint to gather this data.

    Sample data table: 

    | Commit Sha |date|  
    |----------- |----|
    |0734a1482f009b4c6c8dbe16e34daf3c75567373|2015-04-15 21:40:03 UTC|
    |b71398d37c208a57e006753bcd6fd7ccee89357a|2015-04-15 20:25:37 UTC|

    The links to the entire data set for this extractor can be found here
    * [Project 1](features/uneven_commits/feature_results/project_1_commits.csv)
    * [Project 2](features/uneven_commits/feature_results/project_2_commits.csv)
    * [Project 3](features/uneven_commits/feature_results/project_3_commits.csv)


- __Bad smells detector__
    
    We are analysing the number of commits per week. If any week has number of commits more/less than 2 standard deviation from the mean(of commits) we would consider it as bad smell. This is an indication that work hasn't been distributed evenly and majority of the work was done in 'red flagged week'.
    The bad smell detector can be found here [smell.rb](./features/uneven_commits/smell.rb)

        commits_in_a_week > mean + 2 * standard_deviation 
        OR  commits_in_a_week < mean + 2 * standard_deviation
      
- __Bad smells results__
    
    The graphs for the results are as follows:
    
    ![](./features/uneven_commits/smell_results/project_1_commits.png)<br>
    **Mean:** 12.1 <br>
    **Std Dev.:** 20.49<br>
    **Redflagged week:** 8 with 72 commits __Bad Smell__

    ![](./features/uneven_commits/smell_results/project_2_commits.png)<br>
    **Mean:** 36.42 <br>
    **Std Dev.:** 36.059<br>
    **Redflagged week:** 13 with 133 commits __Bad Smell__

    ![](./features/uneven_commits/smell_results/project_3_commits.png)<br>
    **Mean:** 18.2  <br>
    **Std Dev.:** 19.06<br>
    **Redflagged week:** 10 with 62 commits __Bad Smell__

**2. Uneven Time Distribution For Milestones**

- __Feature Detection__
    
    In this feature extractor we want to analyse the actual time spent in each milestone. We would accomplish this by finding the cummulative time spent (in hours) on each issue within each milestone. The code for data collection can be found here [scraper.rb](features/uneven_milestones/scraper.rb)

- __Feature detection results__
    
    Inorder to create the above feature we need the every milestone's 'commit sha', '', 'closed_at' attributes, we would also require 'created_at' attribute for the first milestone. We have used [milestones](https://developer.github.com/v3/repos/milestones/) API endpoint to gather this data.

    Sample data table: 

    | Milestone |created_at| closed_at| Time Spent (Days) |
    |-----------|----------|----------|------------------
    |Milestone 1: Feasibility & Requirement Analysis|2015-02-15 21:40:03 UTC| 2015-02-28 20:25:37 UTC | 13|
    |Milestone 2: Minimum Viable Product (MVP)|2015-02-28 20:25:37 UTC| 2015-03-20 20:25:37 UTC | 20|

    The links to the entire data set for this extractor can be found here
    * [Project 1](features/uneven_milestones/feature_results/project_1_commits.csv)
    * [Project 2](features/uneven_milestones/feature_results/project_2_commits.csv)
    * [Project 3](features/uneven_milestones/feature_results/project_3_commits.csv)

- __Bad smells detector__
    
    We are analysing time spent per milestone. If any milestone has number of days spent more/less than 2 standard deviation from the mean(of days) we would consider it as bad smell. We would validate against the general trend that developers don't spent much time on last few milestones (which is mostly testing) due to time constraints which leads to poor software quality. We would identify such 'red flagged milestones'.
    The bad smell detector can be found here [smell.rb](./features/uneven_milestones/smell.rb)

        days_in_a_milestone > mean + 2 * standard_deviation 
        OR  days_in_a_milestone < mean + 2 * standard_deviation
      
- __Bad smells results__
    
    The graphs for the results are as follows:
    
    ![](./features/uneven_milestones/smell_results/project_1_commits.png)
    **Mean:** 12.1 <br>
    **Std Dev.:** 20.49<br>
    **Redflagged week:** 8 with 72 commits __Bad Smell__

    ![](./features/uneven_commits/smell_milestones/project_2_commits.png)
    **Mean:** 36.42 <br>
    **Std Dev.:** 36.059<br>
    **Redflagged week:** 13 with 133 commits __Bad Smell__

    ![](./features/uneven_commits/smell_milestones/project_3_commits.png)
    **Mean:** 18.2  <br>
    **Std Dev.:** 19.06<br>
    **Redflagged week:** 10 with 62 commits __Bad Smell__

**3. Uneven Commits Per Person**

- __Feature Detection__
    
    In this feature extractor we aim to find the dictators and passangers in a project. We would analyse the number of commits per person throughout the project. The code for data collection can be found here [scraper.rb](features/uneven_person_commits/scraper.rb)

- __Feature detection results__
    
    Inorder to create the above feature we need the every constributor's 'name' and 'commit sha'. We would then calculate the number of commits performed by a contributor. We have used [commits](https://developer.github.com/v3/repos/commits/) API endpoint to gather this data.

    Sample data table: 

    | Contributor |Commits| 
    |-------------|----------|
    |Person 1|23|
    |Person 2|160|

    The links to the entire data set for this extractor can be found here
    * [Project 1](features/uneven_person_commits/feature_results/project_1_person_commits.csv)
    * [Project 2](features/uneven_person_commits/feature_results/project_2_person_commits.csv)
    * [Project 3](features/uneven_person_commits/feature_results/project_3_person_commits.csv)


- __Bad smells detector__
    
    We are analysing the number of commits per contributor. If a contributor has number of commits less than 10% is identified as passanger and a contributor having commits greater than 75% is identified as dictator. This is an indication that work hasn't been distributed evenly amongst contributors and majority of the work was done by a set if individuals 'red flagged contributor'.
    The bad smell detector can be found here [smell.rb](./features/uneven_person_commits/smell.rb)

        commits_per_person < 10% 
        OR  commits_per_person > 75%
      
- __Bad smells results__
    
    The graphs for the results are as follows:
    
    ![](./features/uneven_commits/uneven_person_commits/project_1_person_commits.png)
    **Mean:** 12.1 <br>
    **Std Dev.:** 20.49<br>
    **Redflagged week:** 8 with 72 commits __Bad Smell__

    ![](./features/uneven_commits/uneven_person_commits/project_2_person_commits.png)
    **Mean:** 36.42 <br>
    **Std Dev.:** 36.059<br>
    **Redflagged week:** 13 with 133 commits __Bad Smell__

    ![](./features/uneven_commits/uneven_person_commits/project_3_person_commits.png)
    **Mean:** 18.2  <br>
    **Std Dev.:** 19.06<br>
    **Redflagged week:** 10 with 62 commits __Bad Smell__
    
**4. Uneven Issues Per Label**

- __Feature Detection__
    
    In this feature extractor we aim to find irregular use of labels. We would analyse the number of issue per label. To collect this data we fetched the issue events and then collected all the events which had label attribute.  The code for data collection can be found here [scraper.rb](features/uneven_label_issues/scraper.rb)

- __Feature detection results__
    
    Inorder to create the above feature we need the issue 'number', 'action' and the 'label name' attributes. We create a hashmap of label name and its corresponding issue count. We have used [events](https://developer.github.com/v3/issues/events) API endpoint to gather this data.

    Sample data table: 

    | Issue Number | event_created_at | action| label_name|
    |------------- |------------------|-------|-----------|
    |59|2015-04-05 19:12:41 UTC|labeled|Merged|
    |13|2015-04-04 18:33:50 UTC|unlabeled|Awaiting Developer's Feedback|

    The links to the entire data set for this extractor can be found here
    * [Project 1](features/uneven_label_issues/feature_results/project_1_issues_labels.csv)
    * [Project 2](features/uneven_label_issues/feature_results/project_2_issues_labels.csv)
    * [Project 3](features/uneven_label_issues/feature_results/project_3_issues_labels.csv)


- __Bad smells detector__
    
    We are analysing the number of commits per issues. If any label has number of commits more/less than 2 standard deviation from the mean(of commits) we would consider it as bad smell. This is an indication that that label could have been broken into more labels that would ave encouraged equal distrubution of issues. We have marked such labels as 'Redflagged labels'.
    The bad smell detector can be found here [smell.rb](./features/uneven_label_issues/smell.rb)

        commits_per_label > mean + 2 * standard_deviation 
      
- __Bad smells results__
    
    The graphs for the results are as follows:
    
    ![](./features/uneven_label_issues/smell_results/project_1_labels_issues.png)<br>
    **Mean:** 6.39 <br>
    **Std Dev.:** 5.82<br>
    **Redflagged label:** Merged with 19 Issues __Bad Smell__<br>
    **Redflagged label:** Needs Review with 21 Issues __Bad Smell__

    ![](./features/uneven_label_issues/smell_results/project_2_labels_issues.png)<br>
    **Mean:** 11.1 <br>
    **Std Dev.:** 8.82<br>
    **Redflagged label:** solved with 30 issues __Bad Smell__

    ![](./features/uneven_label_issues/smell_results/project_3_labels_issues.png)<br>
    **Mean:** 14.28  <br>
    **Std Dev.:** 11.41<br>
    **Redflagged label:** No red flags

