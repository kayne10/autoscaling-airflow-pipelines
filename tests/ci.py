import unittest
from airflow.models import DagBag

class TestAriflowDags(unittest.TestCase):

    def setUp(self):
        super().setUp()
        self.dag_bag = DagBag()
    
    def test_dags_on_load(self):
        assert self.dag_bag.import_errors == {}



suite = unittest.TestLoader().loadTestsFromTestCase(TestAriflowDags)
unittest.TextTestRunner(verbosity=2).run(suite)