CREATE TABLE institution (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL
);

CREATE TABLE curriculum (
    id SERIAL PRIMARY KEY,
    institution_id INT NOT NULL REFERENCES institution(id),
    subject_code VARCHAR(20) NOT NULL,
    subject_name VARCHAR(200) NOT NULL,
    credits INT NOT NULL CHECK (credits >= 0),
    UNIQUE (institution_id, subject_code)
);

-- Relación muchos-a-muchos: una materia puede tener varios prerrequisitos
CREATE TABLE curriculum_prerequisite (
    curriculum_id INT NOT NULL REFERENCES curriculum(id) ON DELETE CASCADE,
    prerequisite_id INT NOT NULL REFERENCES curriculum(id) ON DELETE CASCADE,
    PRIMARY KEY (curriculum_id, prerequisite_id)
);

CREATE TABLE term (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,          -- Ej. 2026-C3
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK (end_date > start_date)
);

CREATE TABLE enrolled_subject (
    id SERIAL PRIMARY KEY,
    term_id INT NOT NULL REFERENCES term(id) ON DELETE CASCADE,
    curriculum_id INT NOT NULL REFERENCES curriculum(id),
    UNIQUE (term_id, curriculum_id)
);

CREATE TABLE class_session (
    id SERIAL PRIMARY KEY,
    enrolled_subject_id INT NOT NULL REFERENCES enrolled_subject(id) ON DELETE CASCADE,
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    classroom VARCHAR(50),
    CHECK (end_time > start_time)
);

CREATE TABLE task (
    id SERIAL PRIMARY KEY,
    enrolled_subject_id INT NOT NULL REFERENCES enrolled_subject(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    due_date TIMESTAMP NOT NULL,
    priority_level VARCHAR(10) NOT NULL DEFAULT 'Media'
        CHECK (priority_level IN ('Alta', 'Media', 'Baja')),
    status VARCHAR(15) NOT NULL DEFAULT 'Pendiente'
        CHECK (status IN ('Pendiente', 'En Progreso', 'Completada')),
    task_type VARCHAR(15) NOT NULL
        CHECK (task_type IN ('Examen', 'Proyecto', 'Tarea', 'Exposicion'))
);