<?php
class User {
    static function login(string $login, string $password, mysqli $db) : int {
        $sql  = "SELECT id FROM user WHERE email = ? AND passwordHash = "?"";
        $query = $db->prepare($sql);
        $query->bind_param('ss', $login, $password);
        $query->execute();
        $result = $query->get_result();
        if($result->num_rows == 0) {
            throw new Exception('invalid login or password');
        } else {
            
        }
    }
}