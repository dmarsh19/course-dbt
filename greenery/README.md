# Welcome to your new dbt project!

## Using the starter project

Try running the following commands:
- dbt run
- dbt test


## Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Projects

### Week 1

#### How many users do we have?

**130**

```sql
select
    count(distinct user_id)
from
    dbt_derek_m.stg_users;
```

#### On average, how many orders do we receive per hour?

**7.5208333333333333**

```sql
with hourly_orders as (
  select
    count(*) as cnt
  from
    dbt_derek_m.stg_orders
  group by
    date_trunc('hour', created_at)
)
select
  avg(cnt)
from
  hourly_orders;
```

#### On average, how long does an order take from being placed to being delivered?

**3 days 21:24:11.803279**

```sql
select
  avg(delivered_at - created_at)
from
  dbt_derek_m.stg_orders
where
  delivered_at is not null;
```

#### How many users have only made one purchase? Two purchases? Three+ purchases?

- One purchase: **25**
- Two purchases: **28**
- Three or more purchases: **71**

```sql
with user_orders as (
  select
    count(*) as cnt
  from
    dbt_derek_m.stg_orders
  group by
    user_id
)
select
  CASE cnt
    WHEN 1 THEN 1
    WHEN 2 THEN 2
    ELSE 3
  END,
  count(*)
from
  user_orders
group by
  1;
```

#### On average, how many unique sessions do we have per hour?

**16.3275862068965517**

```sql
with hourly_sessions as (
  select
    count(distinct session_id) as uniq_cnt
  from
    dbt_derek_m.stg_events
  group by
    date_trunc('hour', created_at)
)
select
  avg(uniq_cnt)
from
  hourly_sessions;
```

### Week 2

#### What is our user repeat rate?

**79.83870967741935**

```sql
select
  (count(*) filter (where num_orders > 1) / count(*)::real) * 100
from
  dbt_derek_m.fct_user_orders;
```

#### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Good indicators would likely be a user with a high amount of sessions and page views or a user that has used a promo more than once; they are planned buyers and may frequent the site to wait for a deal. Indicators of not purchasing again could be user that has bought the same item more than once; perhaps they had to replace an item or had a bad experience with the first and gave another try. More data that could help answer this question could be reviews on the items linked to user accounts; this would help identify satisfied customers and why they are choosing particular items.

#### Explain the marts models you added. Why did you organize the models in the way you did?

fct_user_orders provides order information at the user level. fct_user_sessions provides session information at the user level. fct_page_views provides information about the page views at the url level. I put user order and address information in marketing; the types of items could impact some soft of mailer or promo that marketing would want to send out to users. Information like page views and sessions tell more about the products provided by greenery; how popular a particular product url is and the amount of time user's spend shopping for products affects not just inventory, but the site itself as a product.

#### dbt docs

<img src="https://github.com/dmarsh19/course-dbt/blob/main/greenery/Screenshot%20from%202022-03-20%2022-10-55.png" height="600" />

#### What assumptions are you making about each model?

I am assuming key values like guids are not null and unique so aggregations are accurate. I am assuming my date calculations are correct and can check that by determining if a last event or last purchase falls after the first event/purchase. Many of my tests are to check for positive values that should be counted or summed out of an aggregation and those tests will tell if I used a sane expression.

#### Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

Didn't catch bad data, but I did go back to a previously written model (marketing/fct_user_orders) and add a test for the user_guid to be not null and unique so I could be confident that any operations using that as a key would return correct user level answers.

#### Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would start with Github Actions running `dbt build` daily and notifying on failure or bad exit code. This would run all the tests and rebuild data regularly. If more advanced logic or a DAG system like Airflow or Dagster were already used in the environment, that would also be a good option.

### Week 3

#### What is our overall conversion rate?

**62.45674740484429**

```sql
with sessions as (
  select
    session_guid,
    sum(checkout) as checkout
  from
    dbt_derek_m.int_session_events_agg
  group by
    1
)
select
  (count(*) filter (where checkout > 0) / count(*)::real) * 100
from
  sessions;
```

#### What is our conversion rate by product?

I spent enough time spinning my wheels on this question. Felt I was getting close.

****

```sql
```

#### Why might certain products be converting at higher/lower rates than others? 

****

<img src="https://github.com/dmarsh19/course-dbt/blob/main/greenery/dag2.png" height="600" />
