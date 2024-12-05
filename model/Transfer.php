<?php
class Transfer {
    public static function new(int $source, int $target, int $amount, mysqli $db) : void {
        //rozpocznij transakcje
        $db->begin_transaction();
        try {
            //sql - odjęcie kwoty z rachunku 1
            $sql = "UPDATE account SET amount = amount - ? WHERE accountNo = ?";
            //przygotuj zapytanie
            $query = $db->prepare($sql);
            //podmień znaki zapytania na zmienne
            $query->bind_param('ii', $amount, $source);
            //wykonaj zapytanie
            $query->execute();
            //dodaj kwotę do rachunku 2
            $sql = "UPDATE account SET amount = amount + ? WHERE accountNo = ?";
            //przygotuj zapytanie
            $query = $db->prepare($sql);
            //podmień znaki zapytania na zmienne
            $query->bind_param('ii', $amount, $target);
            //wykonaj zapytanie
            $query->execute();
            //zapisz informację o przelewie do bazy danych
            $sql = "INSERT INTO transfer (source, target, amount) VALUES (?, ?, ?)";
            //przygotuj zapytanie
            $query = $db->prepare($sql);
            //podmień znaki zapytania na zmienne
            $query->bind_param('iii', $source, $target, $amount);
            //wykonaj zapytanie
            $query->execute();
            //zakończ transakcje
            $db->commit();
        } catch (mysqli_sql_exception $e) {
            //jeżeli wystąpił błąd to wycofaj transakcje
            $db->rollback();
            //rzuć wyjątek
            throw new Exception('Transfer failed');
        }
        
    }

    public static function getTransfersByAccount($accountNo, $db) {
        $stmt = $db->prepare("SELECT * FROM transfer WHERE source = ? OR target = ?");
        $stmt->bind_param("ss", $accountNo, $accountNo);
        $stmt->execute();
        $result = $stmt->get_result();
        $transfers = [];
        while ($row = $result->fetch_assoc()) {
            $transfers[] = $row;
        }
        return $transfers;
    }
}

class TransfersRequest {
    private string $token;

    public function __construct() {
        $data = file_get_contents('php://input');
        $dataArray = json_decode($data, true);
        $this->token = $dataArray['token'];
    }

    public function getToken(): string {
        return $this->token;
    }
}

class TransfersResponse {
    private array $transfers;
    private string $error;

    public function __construct() {
        $this->transfers = [];
        $this->error = "";
    }

    public function getJSON() {
        $array = array();
        $array['transfers'] = $this->transfers;
        $array['error'] = $this->error;
        return json_encode($array);
    }

    public function setTransfers(array $transfers) {
        $this->transfers = $transfers;
    }

    public function setError(string $error) {
        $this->error = $error;
    }

    public function send() {
        if ($this->error != "") {
            header('HTTP/1.1 401 Unauthorized');
        } else {
            header('HTTP/1.1 200 OK');
        }
        header('Content-Type: application/json');
        echo $this->getJSON();
    }
}
?>