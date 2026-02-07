# Meal Planning & Tracking App - Detailed Specification

## Overview
A meal planning and nutritional tracking application that uses OpenAI's GPT-4o to generate personalized meal plans based on user preferences, dietary goals, and macro targets. Users can log their meals, track their macro intake, and manage their nutrition over time.

## Technology Stack

### Frontend
- **Framework**: Flutter
- **Target Platforms**: Android and iOS mobile apps
- **State Management**: TBD (Provider, Riverpod, or Bloc)

### Backend
- **Framework**: FastAPI (Python)
- **Database**: SQLite
- **Containerization**: Docker
- **API Integration**: OpenAI GPT-4o

### Deployment
- Docker containerization for backend
- Flexible deployment - should support various hosting environments:
  - Self-hosted servers
  - Cloud platforms (AWS, GCP, Azure)
  - VPS providers (DigitalOcean, Linode)
  - Any environment that supports Docker

## Core Features

### 1. User Management
- **Multi-user support** with authentication
- Email/password based authentication
- User profiles with individual goals and preferences
- Data isolation per user

### 2. Goal Setting & Configuration

#### Calorie & Macro Goals
- **TDEE Calculator** with manual override capability
  - Input: age, weight, height, activity level, goal (cutting/bulking/maintenance)
  - Output: recommended daily calories
  - Users can override calculated values
- **Macro targets** support both formats (user chooses):
  - **Percentage ratios** (e.g., 40% protein, 30% carbs, 30% fat)
  - **Absolute grams** (e.g., 150g protein, 200g carbs, 70g fat)
  - System converts between formats as needed
- **Tracked macronutrients**: Protein, Carbohydrates, Fat (no micronutrient tracking)

#### Meal Structure Configuration
- Users specify:
  - Number of meals per day (e.g., 3, 4, 5)
  - Number of snacks per day (e.g., 0, 1, 2, 3)
- Fixed structure per plan (not flexible meal timing)

#### Food Preferences
- **Free-text input** for dietary preferences
- Examples: "I like chicken and rice, avoid dairy, no shellfish"
- OpenAI interprets preferences naturally
- Users can update preferences at any time

### 3. Meal Plan Generation

#### Plan Configuration
- **Flexible duration**: Support both single-day and multi-day plans
  - User can generate 1-14 days at a time
  - Choose based on planning style preference

#### Generation Process
- User initiates generation with current goals and preferences
- Backend calls OpenAI GPT-4o API with structured prompt containing:
  - Daily calorie target
  - Macro targets (protein/carbs/fat in grams)
  - Meal structure (X meals + Y snacks)
  - Food preferences (free-text)
  - Number of days to generate
- API returns structured meal plan with:
  - Specific foods and portions (in grams/oz)
  - Calculated macros per meal
  - Total daily macros
  - Variety across days (for multi-day plans)

#### Error Handling
- **Auto-retry with exponential backoff**
  - Retry up to 3 times on API failure
  - Wait: 2s, 4s, 8s between retries
- Show user-friendly error message if all retries fail
- Allow manual retry

#### Plan Editing
- **Regenerate individual meals**: Users can request regeneration of specific meals (e.g., "I don't like this dinner, generate a new one")
- **Accept or decline entire plan**: Users must accept a plan before it becomes active
- Once accepted, plan becomes the active tracking plan

### 4. Grocery List Generation
- **Auto-generate** upon plan acceptance
- Aggregates all ingredients across all meals in the plan
- Groups by food type/category
- Shows quantities in grams/oz (same units as meal plan)
- Users can view and reference the list (no manual editing in MVP)

### 5. Meal Logging

#### Logging Workflow
- **Log plan only** - simplified approach
- Users see their active plan for the current day
- For each planned meal/snack, users can:
  - Mark as "Eaten" (logged at full planned portion)
  - Mark as "Skipped" (not consumed)
- Cannot log foods outside the plan
- Cannot adjust portions (log full meal or skip it)

#### Daily Tracking
- View today's meals with logging status
- See running macro totals for the day (updates as meals are logged)
- See remaining macros for the day
- Simple progress indicators (calories and each macro)

### 6. History & Analytics

#### Plan History
- **Keep all generated plans** with associated logs
- Historical plans show:
  - Generation date
  - Plan duration
  - Goals at time of generation
  - Which meals were logged as eaten/skipped

#### Analytics Dashboard
- **Daily macro totals**: View total protein/carbs/fat consumed each day
- Calendar view showing:
  - Days with active plans
  - Days with logged meals
  - Daily calorie totals
- Summary statistics:
  - Average daily calories (7-day, 30-day)
  - Average macro intake
  - Logging consistency

### 7. OpenAI API Key Management

#### Hybrid Approach
- **Default**: App provides built-in API key
  - Usage limits per user (e.g., 10 plan generations per month)
  - Prevents abuse and controls costs
  - Easy onboarding for new users
- **Optional**: Users can provide their own OpenAI API key
  - Unlimited generations
  - Direct billing to their OpenAI account
  - Key stored encrypted in database
- Settings UI to add/remove personal API key

## Data Models

### User
```python
- id: UUID
- email: string (unique)
- hashed_password: string
- created_at: timestamp
- updated_at: timestamp
```

### UserProfile
```python
- user_id: UUID (FK to User)
- food_preferences: text
- meals_per_day: int
- snacks_per_day: int
- openai_api_key_encrypted: string (optional)
- api_usage_count: int (for built-in key limits)
- api_usage_reset_date: timestamp
- created_at: timestamp
- updated_at: timestamp
```

### NutritionGoal
```python
- id: UUID
- user_id: UUID (FK to User)
- daily_calories: int
- macro_format: enum ('percentage', 'absolute')
- protein_target: float (% or grams based on format)
- carb_target: float
- fat_target: float
- is_active: boolean
- created_at: timestamp
```

### MealPlan
```python
- id: UUID
- user_id: UUID (FK to User)
- goal_id: UUID (FK to NutritionGoal, snapshot of goals at generation)
- start_date: date
- duration_days: int
- status: enum ('pending', 'accepted', 'archived')
- generated_at: timestamp
- accepted_at: timestamp (nullable)
```

### PlannedMeal
```python
- id: UUID
- meal_plan_id: UUID (FK to MealPlan)
- day_index: int (0-based, 0 = first day of plan)
- meal_type: enum ('meal', 'snack')
- meal_index: int (e.g., meal 1, meal 2, snack 1)
- name: string (e.g., "Grilled Chicken with Rice")
- foods: JSON array of {food: string, quantity_grams: float}
- protein_grams: float
- carb_grams: float
- fat_grams: float
- calories: int
```

### MealLog
```python
- id: UUID
- user_id: UUID (FK to User)
- planned_meal_id: UUID (FK to PlannedMeal)
- log_date: date
- status: enum ('eaten', 'skipped')
- logged_at: timestamp
```

### GroceryList
```python
- id: UUID
- meal_plan_id: UUID (FK to MealPlan)
- items: JSON array of {food: string, total_quantity_grams: float, category: string}
- generated_at: timestamp
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Create new user account
- `POST /api/auth/login` - Login, returns JWT token
- `POST /api/auth/logout` - Logout
- `GET /api/auth/me` - Get current user info

### User Profile & Goals
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update profile (preferences, meal structure)
- `POST /api/profile/api-key` - Set user's OpenAI API key
- `DELETE /api/profile/api-key` - Remove user's API key
- `GET /api/goals` - Get nutrition goals
- `POST /api/goals` - Create/update active nutrition goal
- `POST /api/goals/calculate-tdee` - Calculate TDEE (returns recommendation)

### Meal Plans
- `POST /api/meal-plans/generate` - Generate new meal plan
  - Body: {start_date, duration_days, regenerate_meal_id: optional}
  - Returns pending meal plan
- `GET /api/meal-plans` - List user's meal plans
- `GET /api/meal-plans/{id}` - Get specific meal plan with all meals
- `POST /api/meal-plans/{id}/accept` - Accept a pending plan
- `POST /api/meal-plans/{id}/regenerate-meal` - Regenerate specific meal
- `DELETE /api/meal-plans/{id}` - Delete a plan

### Grocery Lists
- `GET /api/meal-plans/{id}/grocery-list` - Get grocery list for a plan

### Meal Logging
- `GET /api/logs/today` - Get today's planned meals with log status
- `GET /api/logs/date/{date}` - Get specific date's meals and logs
- `POST /api/logs` - Log a meal
  - Body: {planned_meal_id, status: 'eaten'|'skipped'}
- `GET /api/logs/range` - Get logs for date range

### Analytics
- `GET /api/analytics/daily/{date}` - Get daily macro totals
- `GET /api/analytics/summary` - Get summary stats (7-day, 30-day averages)

## OpenAI Integration

### Prompt Structure
The backend constructs prompts for GPT-4o with the following structure:

```
You are a nutrition expert creating a personalized meal plan.

USER GOALS:
- Daily Calories: {calories}
- Protein: {protein}g
- Carbohydrates: {carbs}g
- Fat: {fat}g

MEAL STRUCTURE:
- {meals_per_day} meals per day
- {snacks_per_day} snacks per day

FOOD PREFERENCES:
{user_preferences}

REQUIREMENTS:
- Generate a {duration_days}-day meal plan
- Provide specific foods with portions in grams
- Calculate exact macros for each meal
- Ensure daily totals match targets (±5% variance allowed)
- Use weight-based measurements (grams/oz)
- Vary meals across days to prevent boredom

Return the meal plan in the following JSON format:
{schema}
```

### Response Format
OpenAI returns structured JSON:
```json
{
  "days": [
    {
      "day": 1,
      "meals": [
        {
          "type": "meal",
          "index": 1,
          "name": "Grilled Chicken with Brown Rice and Broccoli",
          "foods": [
            {"food": "Chicken breast (grilled)", "quantity_grams": 200},
            {"food": "Brown rice (cooked)", "quantity_grams": 150},
            {"food": "Broccoli (steamed)", "quantity_grams": 100}
          ],
          "protein_grams": 52,
          "carb_grams": 48,
          "fat_grams": 8,
          "calories": 468
        },
        ...
      ],
      "daily_totals": {
        "protein_grams": 150,
        "carb_grams": 200,
        "fat_grams": 70,
        "calories": 2010
      }
    }
  ]
}
```

### Model Configuration
- **Model**: gpt-4o
- **Temperature**: 0.7 (balanced creativity and consistency)
- **Max Tokens**: 4000 (sufficient for multi-day plans)
- **JSON Mode**: Enabled for structured output

## UI/UX Flow

### Initial Setup (New User)
1. Registration screen (email, password)
2. Welcome screen explaining the app
3. Goal setup wizard:
   - Personal info for TDEE calculation (optional)
   - Set calorie target (calculated or manual)
   - Choose macro format (percentage or grams)
   - Set macro targets
4. Meal structure setup:
   - How many meals per day?
   - How many snacks?
5. Food preferences input (free-text)
6. Optional: Add personal OpenAI API key
7. Ready to generate first meal plan

### Main App Screens

#### Home / Today View
- Current date prominent
- List of today's meals (from active plan)
- Each meal shows:
  - Meal name
  - Foods and portions
  - Macro breakdown
  - Log button (eaten/skipped)
- Running totals at top:
  - Calories: 850 / 2000
  - Protein: 65g / 150g
  - Carbs: 80g / 200g
  - Fat: 25g / 70g

#### Meal Plans Screen
- "Generate New Plan" button
- List of previous plans:
  - Date range
  - Status (active, completed, archived)
  - Tap to view details
- Active plan highlighted

#### Plan Generation Screen
- Start date picker
- Duration slider (1-14 days)
- "Generate Plan" button
- Shows loading state during generation
- Preview generated plan
- "Accept Plan" or "Generate New" buttons
- Option to regenerate individual meals

#### Grocery List Screen
- Auto-opens after accepting plan
- Grouped by category
- Shows ingredient quantities
- Can access from meal plan details

#### History & Analytics Screen
- Calendar view of logged days
- Daily totals for selected date
- Summary statistics:
  - 7-day average calories
  - 30-day average macros
  - Logging consistency %

#### Profile & Settings Screen
- Edit food preferences
- Edit meal structure
- View/edit nutrition goals
- API key management
- Account settings
- Logout

## Technical Considerations

### Security
- JWT-based authentication
- Password hashing with bcrypt
- OpenAI API keys encrypted at rest (AES-256)
- HTTPS only for API communication
- Rate limiting on API endpoints
- Input validation and sanitization

### Performance
- SQLite suitable for single-server deployment
- Consider connection pooling
- Cache active meal plans in memory
- Optimize queries for analytics (proper indexes)
- OpenAI API calls are async with timeout handling

### Docker Configuration
- **Backend container**:
  - Python 3.11+ base image
  - FastAPI with Uvicorn server
  - SQLite database mounted as volume
  - Environment variables for configuration
  - Health check endpoint
- **Docker Compose** for easy deployment:
  - Backend service
  - Volume for database persistence
  - Environment file for secrets
  - Port mapping (8000:8000)

### Error Handling
- Graceful degradation when OpenAI API unavailable
- Clear error messages for users
- Logging for debugging (structured logs)
- Retry logic with exponential backoff
- Database transaction handling

### Future Considerations (Out of Scope for MVP)
- Recipe database integration
- Social features (share meal plans)
- Integration with fitness trackers
- Meal prep timing guidance
- Photo logging of meals
- Barcode scanning
- Restaurant meal suggestions
- Micronutrient tracking
- Push notifications
- Web dashboard version
- Multiple language support

## Development Phases

### Phase 1: Backend Core
- FastAPI project setup
- Database models and migrations
- Authentication system
- User profile management
- Goal setting endpoints

### Phase 2: OpenAI Integration
- Prompt engineering
- API integration with retry logic
- Meal plan generation endpoint
- Meal regeneration logic
- API key management

### Phase 3: Meal Planning & Logging
- Meal plan CRUD operations
- Grocery list generation
- Meal logging endpoints
- Active plan management

### Phase 4: Analytics
- Historical data queries
- Daily totals calculation
- Summary statistics
- Date range filtering

### Phase 5: Flutter App
- Project setup and structure
- Authentication UI
- Onboarding flow
- Home/Today view
- Meal plan generation UI
- Logging interface
- History and analytics screens
- Profile and settings

### Phase 6: Deployment
- Docker containerization
- Environment configuration
- Deployment documentation
- Testing in target environment

## Success Metrics
- Users can generate meal plans that meet macro targets (±5% variance)
- Meal plan generation completes within 10 seconds (90th percentile)
- Users can log meals quickly (< 3 taps per meal)
- App works reliably on both Android and iOS
- Clear, intuitive UI that requires minimal onboarding

## Open Questions / Future Decisions
- Specific Flutter state management library choice
- Database migration strategy
- Backup and restore functionality
- Data export format
- API versioning strategy
- Rate limiting thresholds for built-in API key
